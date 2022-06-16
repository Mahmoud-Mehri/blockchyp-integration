unit BlockChyp.Threads.CancelPaymentLink;

interface

uses
 SysUtils, Classes, Generics.Collections, Messages, Windows, XSuperObject,
 BlockChyp.Constants,
 BlockChyp.Model.Base,
 BlockChyp.Model.General,
 BlockChyp.Model.Authorization,
 BlockChyp.Adapter;

type
 TCancelPaymentLinkThread = class(TThread)
  private
   FResultHandle: THandle;
   FTransactionRef: String;
   FLinkID: String;
   FAdapter: TBlockChypAdapter;
   FApiKey, FBearerToken, FSigningKey, FTerminalName: String;
   FTranResponse: TAuthorizationResponse;
   FCancelResponse: TBaseResponse;
  public
   property TranResponse: TAuthorizationResponse read FTranResponse;
   property CancelResponse: TBaseResponse read FCancelResponse;
   procedure SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
   procedure SetConfigs(UseGateway, UseSSL, TestMode: Boolean;
     TerminalIP: String = ''; TerminalPort: Integer = 0);
   constructor Create(ResultHandle: THandle; TransRef, LinkId: String);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

implementation

{ TTransactionStatusThread }

constructor TCancelPaymentLinkThread.Create(ResultHandle: THandle; TransRef, LinkId: String);
begin
 inherited Create(True);

 FResultHandle := ResultHandle;
 FTransactionRef := TransRef;
 FLinkID := LinkId;

 FAdapter := TBlockChypAdapter.Create;
end;

destructor TCancelPaymentLinkThread.Destroy;
begin
 FAdapter.Free;

 inherited Destroy;
end;

procedure TCancelPaymentLinkThread.Execute;
begin
 try
  try
   FTranResponse := FAdapter.CheckStatus(FTransactionRef);
   if Assigned(FTranResponse) then
    begin
     if FTranResponse.Approved then
      SendMessage(FResultHandle, MSG_PAYMENTLINK_CANCEL, 3, 0)  // Transaction approved, can't be cancelled
     else
      begin
       FCancelResponse := FAdapter.CancelPaymentLink(FLinkID);
       if Assigned(FCancelResponse) then
        SendMessage(FResultHandle, MSG_PAYMENTLINK_CANCEL, 1, Integer(Pointer(FCancelResponse)))
       else
        SendMessage(FResultHandle, MSG_PAYMENTLINK_CANCEL, 2, 0);
      end
    end
   else
    begin
     FCancelResponse := FAdapter.CancelPaymentLink(FLinkID);
     if Assigned(FCancelResponse) then
      SendMessage(FResultHandle, MSG_PAYMENTLINK_CANCEL, 1, Integer(Pointer(FCancelResponse)))
     else
      SendMessage(FResultHandle, MSG_PAYMENTLINK_CANCEL, 2, 0);
    end;

   Sleep(100);
  except
   on E:Exception do
    begin
     SendMessage(FResultHandle, MSG_TRANSACTION_STATUS, 2, 0);
    end;
  end;
 finally
  if Assigned(FTranResponse) then
   FreeAndNil(FTranResponse);

  if Assigned(FCancelResponse) then
   FreeAndNil(FCancelResponse);
 end;
end;

procedure TCancelPaymentLinkThread.SetConfigs(UseGateway, UseSSL,
  TestMode: Boolean; TerminalIP: String; TerminalPort: Integer);
begin
 FAdapter.UseGateway := UseGateway;
 FAdapter.UseSSL := UseSSL;
 FAdapter.TestMode := TestMode;
 FAdapter.TerminalIP := TerminalIP;
 FAdapter.TerminalPort := TerminalPort.ToString;
end;

procedure TCancelPaymentLinkThread.SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
begin
 FApiKey := ApiKey;
 FBearerToken := BearerToken;
 FSigningKey := SigningKey;
 FTerminalName := TerminalName;

 FAdapter.SetCredentials(FApiKey, FBearerToken, FSigningKey, FTerminalName);
end;

end.
