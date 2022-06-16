unit BlockChyp.Model.Signature;

interface

uses
 SysUtils, Classes, Generics.Collections, XSuperObject,
 BlockChyp.Model.Base,
 BlockChyp.Model.General;

type
  TSignatureRequest = class(TBaseRequest)
   private
    FSigFormat: String;
    FSigWidth: Integer;
   public
    property SigFormat: String read FSigFormat write FSigFormat;
    property SigWidth: Integer read FSigWidth write FSigWidth;
  end;

  TSignatureResponse = class(TBaseResponse)
  private
   FResponseDescription: String;
   FSigFile: String;
  public
   property ResponseDescription: String read FResponseDescription write FResponseDescription;
   property SigFile: String read FSigFile write FSigFile;
 end;

implementation


end.
