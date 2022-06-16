unit BlockChyp.Threads.TransactionStatus;

interface

uses
 SysUtils, Classes, Generics.Collections, Messages, Windows, XSuperObject,
 BlockChyp.Constants,
 BlockChyp.Model.Base,
 BlockChyp.Model.General,
 BlockChyp.Model.Authorization,
 BlockChyp.Adapter;

type
 TTransactionStatusThread = class(TThread)
  private
   FResultHandle: THandle;
   FTransactionRef: String;
   FInterval: Integer; // In Seconds
   FAdapter: TBlockChypAdapter;
   FApiKey, FBearerToken, FSigningKey, FTerminalName: String;
   FTranResponse: TAuthorizationResponse;
  public
   property TranResponse: TAuthorizationResponse read FTranResponse;
   procedure SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
   procedure SetConfigs(UseGateway, UseSSL, TestMode: Boolean;
     TerminalIP: String = ''; TerminalPort: Integer = 0);
   constructor Create(ResultHandle: THandle; TransRef: String; Interval: Integer);
   destructor Destroy; override;
  protected
   procedure Execute; override;
 end;

implementation

{ TTransactionStatusThread }

constructor TTransactionStatusThread.Create(ResultHandle: THandle; TransRef: String; Interval: Integer);
begin
 inherited Create(True);

 FResultHandle := ResultHandle;
 FTransactionRef := TransRef;
 FInterval := Interval;

 FAdapter := TBlockChypAdapter.Create;
end;

destructor TTransactionStatusThread.Destroy;
begin
 FAdapter.Free;

 inherited Destroy;
end;

procedure TTransactionStatusThread.Execute;
begin
 while not Terminated do
  begin
   if FInterval > 0 then
    begin
     Sleep(FInterval * 1000);
     if Terminated then
      Break;
    end;

   try
    try
     FTranResponse := FAdapter.CheckStatus(FTransactionRef);
     if Assigned(FTranResponse) then
      begin
       SendMessage(FResultHandle, MSG_TRANSACTION_STATUS, 1, Integer(Pointer(FTranResponse)));
      end
     else
      SendMessage(FResultHandle, MSG_TRANSACTION_STATUS, 2, 0);

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
   end;

   if FInterval = 0 then
    Break;
  end;
end;

procedure TTransactionStatusThread.SetConfigs(UseGateway, UseSSL,
  TestMode: Boolean; TerminalIP: String; TerminalPort: Integer);
begin
 FAdapter.UseGateway := UseGateway;
 FAdapter.UseSSL := UseSSL;
 FAdapter.TestMode := TestMode;
 FAdapter.TerminalIP := TerminalIP;
 FAdapter.TerminalPort := TerminalPort.ToString;
end;

procedure TTransactionStatusThread.SetCredentials(ApiKey, BearerToken, SigningKey, TerminalName: String);
begin
 FApiKey := ApiKey;
 FBearerToken := BearerToken;
 FSigningKey := SigningKey;
 FTerminalName := TerminalName;

 FAdapter.SetCredentials(FApiKey, FBearerToken, FSigningKey, FTerminalName);
end;

end.
