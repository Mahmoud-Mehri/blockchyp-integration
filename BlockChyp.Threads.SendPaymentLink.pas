unit BlockChyp.Threads.SendPaymentLink;

interface

uses
 SysUtils, Classes, Generics.Collections, Messages, Windows, XSuperObject,
 BlockChyp.Constants,
 BlockChyp.Model.Base,
 BlockChyp.Model.General,
 BlockChyp.Model.PaymentLink,
 BlockChyp.Adapter;

type
 TSendPaymentLinkThread = class(TThread)
  private
   FResultHandle: THandle;
   FRequest: TPaymentLinkRequest;
   FAdapter: TBlockChypAdapter;
   FApiKey, FBearerToken, FSigningKey, FTerminalName: String;
   FLastResponse: TPaymentLinkResponse;
  public
   property LastResponse: TPaymentLinkResponse read FLastResponse;
   procedure SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
   procedure SetConfigs(UseGateway, UseSSL, TestMode: Boolean; TerminalIP: String = ''; TerminalPort: Integer = 0);
   constructor Create(ResultHandle: THandle; Request: TPaymentLinkRequest);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

implementation

{ TTransactionStatusThread }

constructor TSendPaymentLinkThread.Create(ResultHandle: THandle;
   Request: TPaymentLinkRequest);
begin
 inherited Create(True);
 FreeOnTerminate := True;

 FRequest.FromJSON(Request.AsJSON());

// FRequest := TAuthorizationRequest.Create;
// FRequest.Amount := Request.Amount;
// FRequest.TransactionRef := Request.TransactionRef;
// FRequest.ManualEntry := Request.ManualEntry;
// FRequest.TerminalName := Request.TerminalName;

 FAdapter := TBlockChypAdapter.Create;

 FResultHandle := ResultHandle;
end;

destructor TSendPaymentLinkThread.Destroy;
begin
 FAdapter.Free;
 FRequest.Free;

 inherited Destroy;
end;

procedure TSendPaymentLinkThread.Execute;
begin
 try
  try
   FLastResponse := FAdapter.SendPaymentLink(FRequest);
   SendMessage(FResultHandle, MSG_TRANSACTION_END, 1, 0);
  except
   on E:Exception do
    begin
     SendMessage(FResultHandle, MSG_TRANSACTION_END, 2, 0);

    end;
  end;
 finally
  if Assigned(FLastResponse) then
   FreeAndNil(FLastResponse);
 end;
end;

procedure TSendPaymentLinkThread.SetConfigs(UseGateway, UseSSL,
  TestMode: Boolean; TerminalIP: String; TerminalPort: Integer);
begin
 FAdapter.UseGateway := UseGateway;
 FAdapter.UseSSL := UseSSL;
 FAdapter.TestMode := TestMode;
 FAdapter.TerminalIP := TerminalIP;
 FAdapter.TerminalPort := TerminalPort.ToString;
end;

procedure TSendPaymentLinkThread.SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
begin
 FApiKey := ApiKey;
 FBearerToken := BearerToken;
 FSigningKey := SigningKey;
 FTerminalName := TerminalName;

 FAdapter.SetCredentials(FApiKey, FBearerToken, FSigningKey, TerminalName);
end;

end.

