unit BlockChyp.Threads.TerminalTransaction;

interface

uses
 SysUtils, Classes, Generics.Collections, Messages, Windows, XSuperObject,
 BlockChyp.Constants,
 BlockChyp.Model.Base,
 BlockChyp.Model.General,
 BlockChyp.Model.Authorization,
 BlockChyp.Adapter;

type
 TTerminalTransactionThread = class(TThread)
  private
   FResultHandle: THandle;
   FRequest: TAuthorizationRequest;
   FAdapter: TBlockChypAdapter;
   FApiKey, FBearerToken, FSigningKey, FTerminalName: String;
   FLastResponse: TAuthorizationResponse;
  public
   property LastResponse: TAuthorizationResponse read FLastResponse;
   procedure SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
   procedure SetConfigs(UseGateway, UseSSL, TestMode: Boolean; TerminalIP: String = ''; TerminalPort: Integer = 0);
   constructor Create(ResultHandle: THandle; Request: TAuthorizationRequest);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

implementation

{ TTransactionStatusThread }

constructor TTerminalTransactionThread.Create(ResultHandle: THandle;
   Request: TAuthorizationRequest);
begin
 inherited Create(True);
 FreeOnTerminate := True;

 FRequest.FromJSON(Request.AsJSON());

// FRequest := TAuthorizationRequest.Create;
// FRequest.TerminalName := Request.TerminalName;
// FRequest.Test := Request.Test;
// FRequest.Amount := Request.Amount;
// FRequest.TransactionRef := Request.TransactionRef;
// FRequest.ManualEntry := Request.ManualEntry;
// FRequest.PaymentType := Request.PaymentType;
// FRequest.Pan := Request.Pan;

 FAdapter := TBlockChypAdapter.Create;

 FResultHandle := ResultHandle;
end;

destructor TTerminalTransactionThread.Destroy;
begin
 FAdapter.Free;
 FRequest.Free;

 inherited Destroy;
end;

procedure TTerminalTransactionThread.Execute;
begin
 try
  try
   FLastResponse := FAdapter.Charge(FRequest);
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

procedure TTerminalTransactionThread.SetConfigs(UseGateway, UseSSL,
  TestMode: Boolean; TerminalIP: String; TerminalPort: Integer);
begin
 FAdapter.UseGateway := UseGateway;
 FAdapter.UseSSL := UseSSL;
 FAdapter.TestMode := TestMode;
 FAdapter.TerminalIP := TerminalIP;
 FAdapter.TerminalPort := TerminalPort.ToString;
end;

procedure TTerminalTransactionThread.SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
begin
 FApiKey := ApiKey;
 FBearerToken := BearerToken;
 FSigningKey := SigningKey;
 FTerminalName := TerminalName;

 FAdapter.SetCredentials(FApiKey, FBearerToken, FSigningKey, FTerminalName);
end;

end.

