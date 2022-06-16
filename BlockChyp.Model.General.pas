unit BlockChyp.Model.General;

interface

uses
 SysUtils, Classes, System.Hash, Generics.Collections, Messages,
 XSuperObject,
 BlockChyp.Model.Base;

type
 TCardType = (ctCredit, ctDebit, ctEBT, ctBlockchainGiftCard);
 TSignatureFormat = (sfNone, sfPNJ, sfJPG, sfGIF);
 TCvmType = (cvtSignature, cvtOfflinePin, cvtOnlinePin, cvtCdCvm, cvtNoCvm);
 TAvsResponse = (arNotApplicable, arNotSupported, arRetry, arNoMatch, arAddressMatch,
                 arPostalCodeMatch, arAddressAndPostalCodeMatch);

 THeartbeatResponse = class(TBaseResponse)
  private
   FTimestamp: String;
   FClockchain: String;
   FLatestTick: String;
   FMerchantPk: String;
  public
   property Timestamp: String read FTimestamp write FTimestamp;
   property Clockchain: String read FClockchain write FClockchain;
   property LatestTick: String read FLatestTick write FLatestTick;
   property MerchantPk: String read FMerchantPk write FMerchantPk;
 end;

 TCredentials = class(TBaseModel)
  private
   FApiKey: String;
   FBearerToken: String;
   FSigningKey: String;
  public
   property ApiKey: String read FApiKey write FApiKey;
   property BearerToken: String read FBearerToken write FBearerToken;
   property SigningKey: String read FSigningKey write FSigningKey;
 end;

 TWhiteListedCard = class(TBaseModel)
  private
   FBin: String;
   FTrack1: String;
   FTrack2: String;
   FPin: String;
  public
   property Bin: String read FBin write FBin;
   property Track1: String read FTrack1 write FTrack1;
   property Track2: String read FTrack2 write FTrack2;
   property Pin: String read FPin write FPin;
 end;

 TReceiptSuggestions = class(TBaseModel)
  private
   FAid: String;
   FArqc: String;
   FIad: String;
   FArc: String;
   FTc: String;
   FTvr: String;
   FTsi: String;
   FApplicationLabel: String;
   FRequestSignature: Boolean;
   FMaskedPan: String;
   FAuthorizedAmount: String;
   FTransactionType: String;
   FEntryMethod: String;
  public
   property Aid: String read FAid write FAid;
   property Arqc: String read FArqc write FArqc;
   property Iad: String read FIad write FIad;
   property Arc: String read FArc write FArc;
   property Tc: String read FTc write FTc;
   property Tvr: String read FTvr write FTvr;
   property Tsi: String read FTsi write FTsi;
   property ApplicationLabel: String read FApplicationLabel write FApplicationLabel;
   property RequestSignature: Boolean read FRequestSignature write FRequestSignature;
   property MaskedPan: String read FMaskedPan write FMaskedPan;
   property AuthorizedAmount: String read FAuthorizedAmount write FAuthorizedAmount;
   property TransactionType: String read FTransactionType write FTransactionType;
   property EntryMethod: String read FEntryMethod write FEntryMethod;
 end;

 TRawKeyInfo = class(TBaseModel)
  private
   FCurve: String;
   FX: String;
   FY: String;
  public
   property Curve: String read FCurve write FCurve;
   property X: String read FX write FX;
   property Y: String read FY write FY;
 end;

 TTerminalInfo = class(TBaseModel)
  private
   FTerminalName: String;
   FIpAddress: String;
   FCloudRelayEnabled: Boolean;
   FTransientCredentials: TCredentials;
   FPublicKey: String;
   FRawKey: TRawKeyInfo;
  public
   property TerminalName: string read FTerminalName write FTerminalName;
   property IpAddress: string read FIpAddress write FIpAddress;
   property CloudRelayEnabled: Boolean read FCloudRelayEnabled write FCloudRelayEnabled;
   property TransientCredentials: TCredentials read FTransientCredentials write FTransientCredentials;
   property PublicKey: String read FPublicKey write FPublicKey;
   property RawKey: TRawKeyInfo read FRawKey write FRawKey;

   constructor Create;
   destructor Destroy; override;
 end;

 TCustomerToken = class(TBaseModel)
  private
   FToken: String;
   FMaskedPan: String;
   FExpiryMonth: String;
   FExpiryYear: String;
   FPaymentType: String;
  public
   property Token: String read FToken write FToken;
   property MaskedPan: String read FMaskedPan write FMaskedPan;
   property ExpiryMonth: String read FExpiryMonth write FExpiryMonth;
   property ExpiryYear: String read FExpiryYear write FExpiryYear;
   property PaymentType: String read FPaymentType write FPaymentType;
 end;

 TCustomerInfo = class(TBaseModel)
  private
   FId: String;
   FCustomerRef: String;
   FFirstName: String;
   FLastName: String;
   FCompanyName: String;
   FEmailAddress: String;
   FSMSNumber: String;
   //FPaymentMethods: TObjectList<TCustomerToken>;
  public
   property Id: String read FId write FId;
   property CustomerRef: String read FCustomerRef write FCustomerRef;
   property FirstName: String read FFirstName write FFirstName;
   property LastName: String read FLastName write FLastName;
   property CompanyName: String read FCompanyName write FCompanyName;
   property EmailAddress: String read FEmailAddress write FEmailAddress;
   property SmsNumber: String read FSMSNumber write FSMSNumber;
   //property PaymentMethods: TObjectList<TCustomerToken> read FPaymentMethods write FPaymentMethods;
 end;

 TTransactionItemDiscount = class(TBaseModel)
  private
   FDescription: String;
   FAmount: String;
  public
   property Description: String read FDescription write FDescription;
   property Amount: String read FAmount write FAmount;
 end;

 TTransactionItemInfo = class(TBaseModel)
  private
   FId: String;
   FDescription: String;
   FPrice: String;
   FQuantity: Integer;
   FExtended: String;
   FUnitCode: String;
   FCommodityCode: String;
   FProductCode: String;
   FDiscounts: TObjectList<TTransactionItemDiscount>;
  public
   property Id: String read FId write FId;
   property Description: String read FDescription write FDescription;
   property Price: String read FPrice write FPrice;
   property Quantity: Integer read FQuantity write FQuantity;
   property Extended: String read FExtended write FExtended;
   property UnitCode: String read FUnitCode write FUnitCode;
   property CommodityCode: String read FCommodityCode write FCommodityCode;
   property ProductCode: String read FProductCode write FProductCode;
   property Discounts: TObjectList<TTransactionItemDiscount> read FDiscounts write FDiscounts;

   constructor Create;
   destructor Destroy; override;
 end;

 TTransactionInfo = class(TBaseModel)
  private
   FSubtotal: String;
   FTax: String;
   FTotal: String;

   FItems: TObjectList<TTransactionItemInfo>;
  public
   property Subtotal: String read FSubtotal write FSubtotal;
   property Tax: String read FTax write FTax;
   property Total: String read FTotal write FTotal;
   property Items: TObjectList<TTransactionItemInfo> read FItems write FItems;

   constructor Create;
   destructor Destroy;
 end;

implementation

{ TTerminalInfo }

constructor TTerminalInfo.Create;
begin
 FTransientCredentials := TCredentials.Create;
 FRawKey := TRawKeyInfo.Create;
end;

destructor TTerminalInfo.Destroy;
begin
 FTransientCredentials.Free;
 FRawKey.Free;

 inherited Destroy;
end;

{ TTransaction }

constructor TTransactionInfo.Create;
begin
 FItems := TObjectList<TTransactionItemInfo>.Create;
end;

destructor TTransactionInfo.Destroy;
begin
 FItems.Free;

 inherited Destroy;
end;

{ TTransactionItemInfo }

constructor TTransactionItemInfo.Create;
begin
 FDiscounts := TObjectList<TTransactionItemDiscount>.Create;
end;

destructor TTransactionItemInfo.Destroy;
begin
 FDiscounts.Free;

 inherited;
end;

end.
