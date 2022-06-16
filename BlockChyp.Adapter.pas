unit BlockChyp.Adapter;

interface

uses
 SysUtils, Classes, IdHttp, IdGlobal, XSuperObject, REST.Client, REST.Types,
 BlockChyp.Authentication,
 BlockChyp.Constants,
 BlockChyp.Model.Base,
 BlockChyp.Model.General,
 BlockChyp.Model.Authorization,
 BlockChyp.Model.PaymentLink,
 BlockChyp.Model.Void,
 BlockChyp.Model.Refund,
 BlockChyp.Model.Enroll,
 BlockChyp.Model.Signature;

type
 TRequestType = (rtGET, rtPOST, rtPUT, rtDELETE);

 TBlockChypAdapter = class
  private
   FHttp: TIdHTTP;
   FClient: TRestClient;

   FPublicKey: String;
   FApiKey: String;
   FBearerToken: String;
   FSigningKey: String;
   FTerminalName: String;
   FTimeout: Integer;
   FTestMode: Boolean;
   FUseGateway: Boolean;
   FTerminalIP: String;
   FTerminalPort: String;
   FUseSSL: Boolean;
   FHeaders, FParams: TStringList;

   FLastSignature: TMemoryStream;
   
   function GetBaseUrl: String;
   procedure MakeNewHeader;
   procedure SetRequestOptions(var Request: TBaseRequest; SetTerminalName: Boolean = True);
   function SendRequest(RequestType: TRequestType; Path: String; 
    Params, Headers: TStringList; Body: String): TRESTResponse;

   procedure ValidateChargeRequest(RequestInfo: TAuthorizationRequest);
   function SetSignatureData(SignData: String): Boolean;
   //procedure SetAuthorizationInfo;
  public
   property PublicKey: String read FPublicKey;
   property ApiKey: String read FApiKey;
   property BearerToken: String read FBearerToken;
   property SigningKey: String read FSigningKey;
   property TerminalName: String read FTerminalName;
   property TimeOut: Integer read FTimeOut write FTimeOut;
   property TestMode: Boolean read FTestMode write FTestMode;
   property UseGateway: Boolean read FUseGateway write FUseGateway;
   property TerminalIP: String read FTerminalIP write FTerminalIP;
   property TerminalPort: String read FTerminalPort write FTerminalPort;
   property UseSSL: Boolean read FUseSSL write FUseSSL;

   property LastSignature: TMemoryStream read FLastSignature write FLastSignature;

   procedure SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
   function Heartbeat: THeartbeatResponse;
   
   function Charge(RequestInfo: TAuthorizationRequest): TAuthorizationResponse;
//   function Preauthorization
//   function CapturePreauthorization
   function Refund(RequestInfo: TRefundRequest): TRefundResponse;
   function Enroll(RequestInfo: TEnrollRequest): TEnrollResponse;
   function Void(TransactionId: String): TVoidResponse;
   function Reverse(TransactionRef: String): TVoidResponse; // Same as VOID but using Transaction Reference instead of ID
   function SendPaymentLink(RequestInfo: TPaymentLinkRequest): TPaymentLinkResponse;
   function CancelPaymentLink(LinkCode: String): TBaseResponse;
   function CaptureSignature(RequestInfo: TSignatureRequest): TSignatureResponse;
   function CheckStatus(TransactionRef: String): TAuthorizationResponse;

   constructor Create;
   destructor Destroy; override;
 end;

implementation

{ TBlockChypAdapter }

function TBlockChypAdapter.CancelPaymentLink(LinkCode: String): TBaseResponse;
var
 RequestInfo: TCancelPaymentLinkRequest;

 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 RequestInfo := TCancelPaymentLinkRequest.Create;
 RequestInfo.LinkCode := LinkCode;

 Response := TBaseResponse.Create;
 Result := TBaseResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));

   FParams.Clear;

   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_CANCELPAYLINK, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      Result.FromJSON(Res.Content)
     else
      begin
       Result.Success := False;
//       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
//       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
//       Result.Approved := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
//     Result.Approved := False;
     Result.Error := 'Exception' + E.Message;
     Result.ResponseDescription := 'Exception' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
  RequestInfo.Free;
 end;
end;

function TBlockChypAdapter.CaptureSignature(RequestInfo: TSignatureRequest): TSignatureResponse;
var
 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 Response := TBaseResponse.Create;
 Result := TSignatureResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo), True);

   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_SIGNATURE, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      begin
       Result.FromJSON(Res.Content);
       SetSignatureData(Result.SigFile);
      end
     else
      begin
       Result.Success := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Error := 'Exception: ' + E.Message;
     REsult.ResponseDescription := 'Exception: ' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
 end;
end;

function TBlockChypAdapter.Charge(RequestInfo: TAuthorizationRequest): TAuthorizationResponse;
var
 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 Response := TBaseResponse.Create;
 Result := TAuthorizationResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   ValidateChargeRequest(RequestInfo);
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo), not RequestInfo.ManualEntry);

   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_CHARGE, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      Result.FromJSON(Res.Content)
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Approved := False;
     Result.Error := 'Exception: ' + E.Message;
     REsult.ResponseDescription := 'Exception: ' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
 end;
end;

function TBlockChypAdapter.CheckStatus(TransactionRef: String): TAuthorizationResponse;
var
 RequestInfo: TBaseRequest;

 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 RequestInfo := TBaseRequest.Create;
 RequestInfo.TransactionRef := TransactionRef;

 Response := TBaseResponse.Create;
 Result := TAuthorizationResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));

   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_TXSTATUS, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      Result.FromJSON(Res.Content)
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Approved := False;
     Result.Error := 'Exception' + E.Message;
     REsult.ResponseDescription := 'Exception' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
 end;
end;

constructor TBlockChypAdapter.Create;
begin
 FHttp := TIdHTTP.Create(nil);
 FClient := TRESTClient.Create(nil);
 FHeaders := TStringList.Create;
 FParams := TStringList.Create;
 FLastSignature := TMemoryStream.Create;

 FTimeOut := 60;
end;

destructor TBlockChypAdapter.Destroy;
begin
 FHttp.Disconnect;
 FHttp.Free;

 FClient.Disconnect;
 FClient.Free;

 FHeaders.Free;
 FParams.Free;

 if FLastSignature.Size > 0 then
  FLastSignature.Clear;
 FLastSignature.Free;

 inherited Destroy;
end;

function TBlockChypAdapter.Enroll(RequestInfo: TEnrollRequest): TEnrollResponse;
var
 Res: TRESTResponse;
begin
 Result := TEnrollResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));
   
   FParams.Clear;
      
   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_ENROLL, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    Result.FromJSON(Res.Content)
   else
    begin
     Result.Success := False;
     Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
     Result.ResponseDescription := Res.Content;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Error := 'Exception: ' + E.Message;
    end;
  end;
 finally
  Res.Free;
 end;
end;

function TBlockChypAdapter.GetBaseUrl: String;
begin
 if UseGateway then
  begin
   if TestMode then
    Result := BLOCKCHYP_URL_TEST
   else
    Result := BLOCKCHYP_URL_MAIN;
  end
 else
  begin
   if UseSSL then
    Result := 'HTTPS://' + FTerminalIP + ':' + FTerminalPort
   else
    Result := 'HTTP://' + FTerminalIP + ':' + FTerminalPort;
  end;
end;

procedure TBlockChypAdapter.MakeNewHeader;
var
 Data: TAuthorizationInfo;
begin
 FHeaders.Clear;
 
 Data.APIKey := FApiKey;
 Data.BearerToken := FBearerToken;
 Data.SigningKey := FSigningKey;

 if GenerateHMAC(Data) then
  begin
   FHeaders.Values['Timestamp'] := Data.TimeStamp;
   FHeaders.Values['Nonce'] := Data.Nonce;
   FHeaders.Values['Authorization'] := 'Dual ' + Data.BearerToken + ':' + Data.APIKey + ':' + Data.HMAC;
  end;
end;

function TBlockChypAdapter.Refund(RequestInfo: TRefundRequest): TRefundResponse;
var
 Res: TRESTResponse;
begin
 Result := TRefundResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));
   
   FParams.Clear;
      
   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_REFUND, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    Result.FromJSON(Res.Content)
   else
    begin
     Result.Success := False;
     Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
     Result.ResponseDescription := Res.Content;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Error := 'Exception: ' + E.Message;
    end;
  end;
 finally
  Res.Free;
 end;
end;

function TBlockChypAdapter.Reverse(TransactionRef: String): TVoidResponse;
var
 RequestInfo: TVoidRequest;

 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 RequestInfo := TVoidRequest.Create;
 RequestInfo.TransactionRef := TransactionRef;

 Response := TBaseResponse.Create;
 Result := TVoidResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));

   FParams.Clear;

   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_REVERSE, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      Result.FromJSON(Res.Content)
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Approved := False;
     Result.Error := 'Exception: ' + E.Message;
     Result.ResponseDescription := 'Exception: ' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
  RequestInfo.Free;
 end;
end;

function TBlockChypAdapter.Heartbeat: THeartbeatResponse;
var
 Res: TRESTResponse;
begin
 Result := THeartbeatResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   FParams.Clear;
   
   Res := SendRequest(rtGET, BLOCKCHYP_PATH_HEARTBEAT, FParams, FHeaders, '');
   if Res.StatusCode = 200 then
    Result.FromJSON(Res.Content)
   else
    begin
     Result.Success := False;
     Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
     Result.ResponseDescription := Res.Content;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Error := 'Exception: ' + E.Message;
    end;
  end;
 finally
  Res.Free;
 end;
end;

function TBlockChypAdapter.SendPaymentLink(RequestInfo: TPaymentLinkRequest): TPaymentLinkResponse;
var
 Res: TRESTResponse;
begin
 Result := TPaymentLinkResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));
   
   FParams.Clear;
      
   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_PAYMENTLINK, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    Result.FromJSON(Res.Content)
   else
    begin
     Result.Success := False;
     Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
     Result.ResponseDescription := Res.Content;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Error := 'Exception: ' + E.Message;
    end;
  end;
 finally
  Res.Free;
 end;
end;

function TBlockChypAdapter.SendRequest(RequestType: TRequestType; Path: String; 
  Params, Headers: TStringList; Body: String): TRESTResponse;
var
 Req: TRESTRequest;
 Res: TRESTResponse;
 I: Integer;
begin
 Result := TRESTResponse.Create(nil);
 Req := TRESTRequest.Create(nil);
 try
  FClient.BaseURL := GetBaseUrl;
  FClient.ContentType := 'application/json';
  Req.Timeout := 60000;
  Req.Client := FClient;
  Req.Response := Result;
  case RequestType of
   rtGET : Req.Method := rmGET;
   rtPOST: Req.Method := rmPOST;
   rtPUT : Req.Method := rmPUT;
   rtDELETE: Req.Method := rmDELETE;
  end;
  Req.Accept := 'application/json';
  //Req.AcceptCharset := 'UTF-8';
  Req.Resource := Path;
  //Req.HandleRedirects := True;
  Req.Params.Clear;
  
  for I := 0 to Headers.Count - 1 do
   Req.AddParameter(Headers.Names[I], Headers.ValueFromIndex[I], pkHTTPHEADER, [poDoNotEncode]);

  for I := 0 to Params.Count - 1 do
   Req.AddParameter(Params.Names[I], Params.ValueFromIndex[I], pkQUERY, [poDoNotEncode]);

  if Body <> '' then
   Req.Body.Add(Body, ctAPPLICATION_JSON);

  try
   Req.Execute;
  except
   on E:Exception do
    begin
     if Result.StatusCode = 404 then
      begin

      end;
    end;
  end;
 finally
  Req.Free;
 end;  
end;

procedure TBlockChypAdapter.SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
begin
 FApiKey := ApiKey;
 FBearerToken := BearerToken;
 FSigningKey := SigningKey;
 FTerminalName := TerminalName;
end;

procedure TBlockChypAdapter.SetRequestOptions(var Request: TBaseRequest; SetTerminalName: Boolean = True);
begin
 Request.Test := FTestMode;
 if Request.Timeout = 0 then
  Request.Timeout := FTimeOut;

 if (FTerminalName <> '') and SetTerminalName then
  Request.TerminalName := FTerminalName;
end;

function TBlockChypAdapter.SetSignatureData(SignData: String): Boolean;
var
 Mem: TMemoryStream;
begin
 Result := False;
 if Trim(SignData) = '' then
  Exit(False);

 Mem := TMemoryStream.Create;
 try
  try
   Mem.Size := Length(SignData) div 2;
   HexToBin(PChar(SignData), Mem.Memory^, Mem.Size);

   if Mem.Size > 0 then
    begin
     FLastSignature.Clear;

     Mem.Position := 0;
     FLastSignature.CopyFrom(Mem, Mem.Size);

     Result := True;
    end;
  except
   on E:Exception do
    Result := False;
  end;
 finally
  Mem.Free;
 end;
end;

procedure TBlockChypAdapter.ValidateChargeRequest(RequestInfo: TAuthorizationRequest);
begin
 if not Assigned(RequestInfo) then
  raise Exception.Create('Request Info is not valid');
  
 if RequestInfo.Amount = '' then
  raise Exception.Create('Amount Value is not valid');
end;

function TBlockChypAdapter.Void(TransactionId: String): TVoidResponse;
var
 RequestInfo: TVoidRequest;

 Res: TRESTResponse;
 Response: TBaseResponse;
begin
 RequestInfo := TVoidRequest.Create;
 RequestInfo.TransactionId := TransactionId;

 Response := TBaseResponse.Create;
 Result := TVoidResponse.Create;
 Res := TRESTResponse.Create(nil);
 try
  try
   MakeNewHeader;
   SetRequestOptions(TBaseRequest(RequestInfo));
   
   FParams.Clear;
   
   Res := SendRequest(rtPOST, BLOCKCHYP_PATH_VOID, FParams, FHeaders, RequestInfo.AsJSON);
   if Res.StatusCode = 200 then
    begin
     Response.FromJSON(Res.Content);
     if Response.Success then
      Result.FromJSON(Res.Content)
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end;
    end
   else
    begin
     try
      Response.FromJSON(Res.Content);
     except
      on E:Exception do
       FreeAndNil(Response);
     end;

     if Assigned(Response) then
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Response.Error;
       Result.ResponseDescription := Response.ResponseDescription;
      end
     else
      begin
       Result.Success := False;
       Result.Approved := False;
       Result.Error := Res.StatusCode.ToString + ' - ' + Res.StatusText;
       Result.ResponseDescription := Res.Content;
      end;
    end;
  except
   on E:Exception do
    begin
     Result.Success := False;
     Result.Approved := False;
     Result.Error := 'Exception' + E.Message;
     Result.ResponseDescription := 'Exception' + E.Message;
    end;
  end;
 finally
  if Assigned(Response) then
   Response.Free;
  Res.Free;
  RequestInfo.Free;
 end;
end;

end.
