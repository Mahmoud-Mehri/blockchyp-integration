unit BlockChyp.Model.PaymentLink;

interface

uses
 SysUtils, Classes, Generics.Collections, XSuperObject,
 BlockChyp.Model.Base,
 BlockChyp.Model.General;

type
 TPaymentLinkRequest = class(TBaseRequest)
  private
   FCurrencyCode: String;
   FAmount: String;
   FTaxExempt: Boolean;
   FSurcharge: Boolean;
   FCashDiscount: Boolean;
   FTerminalName: String;
   FAutoSend: Boolean;
   FEnroll: Boolean;
   FEnrollOnly: Boolean;
   FCashier: Boolean;
   FDescription: String;
   FSubject: String;
   FTransaction: TTransactionInfo;
   FCustomer: TCustomerInfo;
   FCallbackUrl: String;
   FTcAlias: String;
   FTcName: String;
   FTcContent: String;
  public
   property CurrencyCode: String read FCurrencyCode write FCurrencyCode;
   property Amount: String read FAmount write FAmount;
   property TaxExempt: Boolean read FTaxExempt write FTaxExempt;
   property Surcharge: Boolean read FSurcharge write FSurcharge;
   property CashDiscount: Boolean read FCashDiscount write FCashDiscount;
   property TerminalName: String read FTerminalName write FTerminalName;
   property AutoSend: Boolean read FAutoSend write FAutoSend;
   property Enroll: Boolean read FEnroll write FEnroll;
   property EnrollOnly: Boolean read FEnrollOnly write FEnrollOnly;
   property Cashier: Boolean read FCashier write FCashier;
   property Description: String read FDescription write FDescription;
   property Subject: String read FSubject write FSubject;
   property Transaction: TTransactionInfo read FTransaction write FTransaction;
   property Customer: TCustomerInfo read FCustomer write FCustomer;
   property CallbackUrl: String read FCallbackUrl write FCallbackUrl;
   property TcAlias: String read FTcAlias write FTcAlias;
   property TcName: String read FTcName write FTcName;
   property TcContent: String read FTcContent write FTcContent;

   constructor Create;
   destructor Destroy; override;
 end;

 TPaymentLinkResponse = class(TBaseResponse)
  private
   FLinkCode: String;
   FUrl: String;
   FCustomerId: String;
  public
   property LinkCode: String read FLinkCode write FLinkCode;
   property Url: String read FUrl write FUrl;
   property CustomerId: String read FCustomerId write FCustomerId;
 end;

 TCancelPaymentLinkRequest = class(TBaseRequest)
  private
   FLinkCode: String;
  public
   property LinkCode: String read FLinkCode write FLinkCode;
 end;

implementation

{ TPaymentLinkRequest }

constructor TPaymentLinkRequest.Create;
begin
 FTransaction := TTransactionInfo.Create;
 FCustomer := TCustomerInfo.Create;
end;

destructor TPaymentLinkRequest.Destroy;
begin
 FTransaction.Free;
 FCustomer.Free;

 inherited Destroy;
end;

end.
