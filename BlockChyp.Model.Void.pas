unit BlockChyp.Model.Void;

interface

uses
 SysUtils, Classes, Generics.Collections, XSuperObject,
 BlockChyp.Model.Base,
 BlockChyp.Model.General;

type
 TVoidRequest = class(TBaseRequest)
  private
   FTransactionId: String;
  public
   property TransactionId: String read FTransactionId write FTransactionId;
 end;

 TVoidResponse = class(TBaseResponse)
  private
   FApproved: Boolean;
   FAuthCode: String;
   FAuthResponseCode: String;
   FTransactionId: String;
   FBatchId: String;
   FTransactionRef: String;
   FTransactionType: String;
   FTimestamp: String;
   FTickBlock: String;
   FTest: Boolean;
  public
   property Approved: Boolean read FApproved write FApproved;
   property AuthCode: String read FAuthCode write FAuthCode;
   property AuthResponseCode: String read FAuthResponseCode write FAuthResponseCode;
   property TransactionId: String read FTransactionId write FTransactionId;
   property BatchId: String read FBatchId write FBatchId;
   property TransactionRef: String read FTransactionRef write FTransactionRef;
   property TransactionType: String read FTransactionType write FTransactionType;
   property Timestamp: String read FTimestamp write FTimestamp;
   property TickBlock: String read FTickBlock write FTickBlock;
   property Test: Boolean read FTest write FTest;
 end;

implementation

end.
