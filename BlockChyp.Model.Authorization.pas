unit BlockChyp.Model.Authorization;

interface

uses
 SysUtils, Classes, Generics.Collections, XSuperObject,
 BlockChyp.Model.Base,
 BlockChyp.Model.General;

type
  TAuthorizationRequest = class(TBaseRequest)
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
    //FCardType: TCardType;
    FPaymentType: String;
    FTransactionId: String;
    FCurrencyCode: String;
    FAmount: String;
    FTaxExempt: Boolean;
    FSurcharge: Boolean;
    FCashDiscount: Boolean;
    FSigFile: String;
    FSigFormat: String;
    FSigWidth: Integer;
    FDisableSignature: Boolean;
    FTipAmount: String;
    FTaxAmount: String;
    FFsaEligibleAmount: String;
    FHsaEligibleAmount: String;
    FEbtEligibleAmount: String;
    FTerminalName: String;
    FOnlineAuthCode: String;
    FEnroll: Boolean;
    FDescription: String;
    FPromptForTip: Boolean;
    FCashBackEnabled: Boolean;
    //FAltPrices: TDictionary<String, String>;
    FCustomer: TCustomerInfo;
   public
    property Token: String read FToken write FToken;
    property Track1: String read FTrack1 write FTrack1;
    property Track2: String read FTrack2 write FTrack2;
    property Pan: String read FPan write FPan;
    property RoutingNumber: String read FRoutingNumber write FRoutingNumber;
    {$REGION 'Card Info'}
    property CardholderName: String read FCardholderName write FCardholderName;
    property ExpMonth: String read FExpMonth write FExpMonth;
    property ExpYear: String read FExpYear write FExpYear;
    property Cvv: String read FCvv write FCvv;
    property Address: String read FAddress write FAddress;
    property PostalCode: String read FPostalCode write FPostalCode;
    {$ENDREGION}
    property ManualEntry: Boolean read FManualEntry write FManualEntry;
    property Ksn: String read FKsn write FKsn;
    property PinBlock: String read FPinBlock write FPinBlock;
    //property CardType: TCardType read FCardType write FCardType;
    property PaymentType: String read FPaymentType write FPaymentType;
    property TransactionId: String read FTransactionId write FTransactionId;
    property CurrencyCode: String read FCurrencyCode write FCurrencyCode;
    property Amount: String read FAmount write FAmount;
    property TaxExempt: Boolean read FTaxExempt write FTaxExempt;
    property Surcharge: Boolean read FSurcharge write FSurcharge;
    property CashDiscount: Boolean read FCashDiscount write FCashDiscount;
    property SigFile: String read FSigFile write FSigFile;
    property SigFormat: String read FSigFormat write FSigFormat;
    property SigWidth: Integer read FSigWidth write FSigWidth;
    property DisableSignature: Boolean read FDisableSignature write FDisableSignature;
    property TipAmount: String read FTipAmount write FTipAmount;
    property TaxAmount: String read FTaxAmount write FTaxAmount;
    property FsaEligibleAmount: String read FFsaEligibleAmount write FFsaEligibleAmount;
    property HsaEligibleAmount: String read FHsaEligibleAmount write FHsaEligibleAmount;
    property EbtEligibleAmount: String read FEbtEligibleAmount write FEbtEligibleAmount;
    property TerminalName: String read FTerminalName write FTerminalName;
    property OnlineAuthCode: String read FOnlineAuthCode write FOnlineAuthCode;
    property Enroll: Boolean read FEnroll write FEnroll;
    property Description: String read FDescription write FDescription;
    property PromptForTip: Boolean read FPromptForTip write FPromptForTip;
    property CashBackEnabled: Boolean read FCashBackEnabled write FCashBackEnabled;
    //property AltPrices: TDictionary<String, String> read FAltPrices write FAltPrices;
    property Customer: TCustomerInfo read FCustomer write FCustomer;

    constructor Create;
    destructor Destroy; override;
  end;

 TAuthorizationResponse = class(TBaseResponse)
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
   FPartialAuth: Boolean;
   FAltCurrency: Boolean;
   FFsaAuth: Boolean;
   FCurrencyCode: String;
   FRequestedAmount: String;
   FAuthorizedAmount: String;
   FRemainingBalance: String;
   FTipAmount: String;
   FTaxAmount: String;
   FRequestedCashBackAmount: String;
   FAuthorizedCashBackAmount: String;
   FToken: String;
   FEntryMethod: String;
   FPaymentType: String;
   FMaskedPan: String;
   FPublicKey: String;
   FScopeAlert: Boolean;
   FCardHolder: String;
   FExpMonth: String;
   FExpYear: String;
   //FAvsResponse: TAvsResponse;
   FCustomer: TCustomerInfo;
   FSigFile: String;
   FReceiptSuggestions: TReceiptSuggestions;
   //FWhiteListedCard: TWhiteListedCard;
   FStoreAndForward: Boolean;
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
   property PartialAuth: Boolean read FPartialAuth write FPartialAuth;
   property AltCurrency: Boolean read FAltCurrency write FAltCurrency;
   property FsaAuth: Boolean read FFsaAuth write FFsaAuth;
   property CurrencyCode: String read FCurrencyCode write FCurrencyCode;
   property RequestedAmount: String read FRequestedAmount write FRequestedAmount;
   property AuthorizedAmount: String read FAuthorizedAmount write FAuthorizedAmount;
   property RemainingBalance: String read FRemainingBalance write FRemainingBalance;
   property TipAmount: String read FTipAmount write FTipAmount;
   property TaxAmount: String read FTaxAmount write FTaxAmount;
   property RequestedCashBackAmount: String read FRequestedCashBackAmount write FRequestedCashBackAmount;
   property AuthorizedCashBackAmount: String read FAuthorizedCashBackAmount write FAuthorizedCashBackAmount;
   property Token: String read FToken write FToken;
   property EntryMethod: String read FEntryMethod write FEntryMethod;
   property PaymentType: String read FPaymentType write FPaymentType;
   property MaskedPan: String read FMaskedPan write FMaskedPan;
   property PublicKey: String read FPublicKey write FPublicKey;
   property ScopeAlert: Boolean read FScopeAlert write FScopeAlert;
   property CardHolder: String read FCardHolder write FCardHolder;
   property ExpMonth: String read FExpMonth write FExpMonth;
   property ExpYear: String read FExpYear write FExpYear;
   //property AvsResponse: TAvsResponse read FAvsResponse write FAvsResponse;
   property Customer: TCustomerInfo read FCustomer write FCustomer;
   property SigFile: String read FSigFile write FSigFile;
   property ReceiptSuggestions: TReceiptSuggestions read FReceiptSuggestions write FReceiptSuggestions;
   //property WhiteListedCard: TWhiteListedCard read FWhiteListedCard write FWhiteListedCard;
   property StoreAndForward: Boolean read FStoreAndForward write FStoreAndForward;

   constructor Create;
   destructor Destroy; override;
 end;

implementation

{ TAuthorizationRequest }

constructor TAuthorizationRequest.Create;
begin
 //FAltPrices := TDictionary<String, String>.Create;
 FCustomer := TCustomerInfo.Create;
end;

destructor TAuthorizationRequest.Destroy;
begin
 //FAltPrices.Free;
 FCustomer.Free;

 inherited Destroy;
end;

{ TAuthorizationResponse }

constructor TAuthorizationResponse.Create;
begin
 FCustomer := TCustomerInfo.Create;
 FReceiptSuggestions := TReceiptSuggestions.Create;
end;

destructor TAuthorizationResponse.Destroy;
begin
 FCustomer.Free;
 FReceiptSuggestions.Create;

 inherited Destroy;
end;

end.
