unit BlockChyp.Model.Base;

interface

uses
 SysUtils, Classes, XSuperObject;

type
 TBaseModel = class

 end;

 TBaseRequest = class(TBaseModel)
  private
   FTerminalName: String;
   FTransactionRef: String;
   FAsync: Boolean;
   FQueue: Boolean;
   FWaitForRemovedCard: Boolean;
   FForce: Boolean;
   FOrderRef: String;
   FDestinationAccount: String;
   FTest: Boolean;
   FTimeout: Integer;
  public
   property TerminalName: String read FTerminalName write FTerminalName;
   property TransactionRef: String read FTransactionRef write FTransactionRef;
   property Async: Boolean read FAsync write FAsync;
   property Queue: Boolean read FQueue write FQueue;
   property WaitForRemovedCard: Boolean read FWaitForRemovedCard write FWaitForRemovedCard;
   property Force: Boolean read FForce write FForce;
   property OrderRef: String read FOrderRef write FOrderRef;
   property DestinationAccount: String read FDestinationAccount write FDestinationAccount;
   property Test: Boolean read FTest write FTest;
   property Timeout: Integer read FTimeout write FTimeout;
 end;

 TBaseResponse = class(TBaseModel)
  private
   FSuccess: Boolean;
   FError: String;
   FResponseDescription: String;
  public
   property Success: Boolean read FSuccess write FSuccess;
   property Error: String read FError write FError;
   property ResponseDescription: String read FResponseDescription write FResponseDescription;
 end;

implementation

end.
