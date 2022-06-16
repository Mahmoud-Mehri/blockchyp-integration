unit BlockChyp.Model.Enroll;

interface

uses
 SysUtils, Classes, Generics.Collections, XSuperObject,
 BlockChyp.Model.Base,
 BlockChyp.Model.General;

type
 TEnrollRequest = class(TBaseRequest)
  private
   FToken: String;
   FTrack1: String;
   FTrack2: String;
   FPan: String;
   FRoutingNumber: String;
   FCardholderName: String;
   FExpMonth: String;
   FExpYear: String;
   FCvv: String;
   FAddress: String;
   FPostalCode: String;
   FManualEntry: Boolean;
   FKsn: String;
   FPinBlock: String;
   FCardType: TCardType;
   FPaymentType: String;
   FTerminalName: String;
   FEntryMethod: String;
   FCustomer: TCustomerInfo;
  public
   property Token: String read FToken write FToken;
   property Track1: String read FTrack1 write FTrack1;
   property Track2: String read FTrack2 write FTrack2;
   property Pan: String read FPan write FPan;
   property RoutingNumber: String read FRoutingNumber write FRoutingNumber;
   property CardholderName: String read FCardholderName write FCardholderName;
   property ExpMonth: String read FExpMonth write FExpMonth;
   property ExpYear: String read FExpYear write FExpYear;
   property Cvv: String read FCvv write FCvv;
   property Address: String read FAddress write FAddress;
   property PostalCode: String read FPostalCode write FPostalCode;
   property ManualEntry: Boolean read FManualEntry write FManualEntry;
   property Ksn: String read FKsn write FKsn;
   property PinBlock: String read FPinBlock write FPinBlock;
   property CardType: TCardType read FCardType write FCardType;
   property PaymentType: String read FPaymentType write FPaymentType;
   property TerminalName: String read FTerminalName write FTerminalName;
   property EntryMethod: String read FEntryMethod write FEntryMethod;
   property Customer: TCustomerInfo read FCustomer write FCustomer;

   constructor Create;
   destructor Destroy; override;
 end;

 TEnrollResponse = class(TBaseResponse)
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
   FDestinationAccount: String;
   FSig: String;
   FToken: String;
   FEntryMethod: String;
   FPaymentType: String;
   FMaskedPan: String;
   FPublicKey: String;
   FScopeAlert: Boolean;
   FCardHolder: String;
   FExpMonth: String;
   FExpYear: String;
   FAvsResponse: TAvsResponse;
   FReceiptSuggestions: TReceiptSuggestions;
   FCustomer: TCustomerInfo;
   FSigFile: String;
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
   property DestinationAccount: String read FDestinationAccount write FDestinationAccount;
   property Sig: String read FSig write FSig;
   property Token: String read FToken write FToken;
   property EntryMethod: String read FEntryMethod write FEntryMethod;
   property PaymentType: String read FPaymentType write FPaymentType;
   property MaskedPan: String read FMaskedPan write FMaskedPan;
   property PublicKey: String read FPublicKey write FPublicKey;
   property ScopeAlert: Boolean read FScopeAlert write FScopeAlert;
   property CardHolder: String read FCardHolder write FCardHolder;
   property ExpMonth: String read FExpMonth write FExpMonth;
   property ExpYear: String read FExpYear write FExpYear;
   property AvsResponse: TAvsResponse read FAvsResponse write FAvsResponse;
   property ReceiptSuggestions: TReceiptSuggestions read FReceiptSuggestions write FReceiptSuggestions;
   property Customer: TCustomerInfo read FCustomer write FCustomer;
   property SigFile: String read FSigFile write FSigFile;

   constructor Create;
   destructor Destroy; override;
 end;

implementation

{ TEnrollResponse }

constructor TEnrollResponse.Create;
begin
 FReceiptSuggestions := TReceiptSuggestions.Create;
 FCustomer := TCustomerInfo.Create;
end;

destructor TEnrollResponse.Destroy;
begin
 FReceiptSuggestions.Free;
 FCustomer.Free;

 inherited Destroy;
end;

{ TEnrollRequest }

constructor TEnrollRequest.Create;
begin
 FCustomer := TCustomerInfo.Create;
end;

destructor TEnrollRequest.Destroy;
begin
 FCustomer.Free;

 inherited Destroy;
end;

end.
