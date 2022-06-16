unit BlockChyp.Authentication;

interface

uses
 SysUtils, Classes, Math, DateUtils, StrUtils, Hash,
 IdGlobal, IdHashSHA, IdHMAC, IdHMACSHA1, IdSSLOpenSSL;

type
 TAuthorizationInfo = record
  PublicKey : String;
  APIKey: String;
  BearerToken: String;
  SigningKey: String;
  TimeStamp: String;
  Nonce: String;
  HMAC: String;
 end;

 function StrToHex(const S: String): String;
 function HexToString(HexStr: String): String;
 function GenerateNonce: String;
 function GenerateHMAC(var Data: TAuthorizationInfo): Boolean;

implementation

function CalculateHMACSHA256(const value: String; salt: TIdBytes): String;
var
  hmac: TIdHMACSHA256;
  hash: TIdBytes;
begin
  LoadOpenSSLLibrary;
  if not TIdHashSHA256.IsAvailable then
    raise Exception.Create('SHA256 hashing is not available!');
  hmac := TIdHMACSHA256.Create;
  try
    hmac.Key := salt;//IndyTextEncoding_UTF8.GetBytes(salt);
    hash := hmac.HashValue(IndyTextEncoding_UTF8.GetBytes(value));
    Result := ToHex(hash).ToLower;
  finally
    hmac.Free;
  end;
end;

function StrToHex(const S: String): String;
const
  HexDigits: array[0..15] of Char = '0123456789ABCDEF';
var
  I: Integer;
  P1: PChar;
  P2: PChar;
  B: Byte;
begin
  SetLength(Result, Length(S) * 2);
  P1 := @S[1];
  P2 := @Result[1];

  for I := 1 to Length(S) do
  begin
    B := Byte(P1^);
    P2^ := HexDigits[B shr 4];
    Inc(P2);
    P2^ := HexDigits[B and $F];
    Inc(P1);
    Inc(P2);
  end;

end;

function HexToString(HexStr: String): String;
var
 TempStr: String;
 I: Integer;
 B: TArray<Byte>;
begin
 SetLength(B, 32);
 HexToBin(PChar(HexStr), PAnsiChar(@B[0]), Length(B));
 //Result := TEncoding.ANSI.GetString(B);
 SetString(Result, PAnsiChar(@B[0]), Length(B));
 //Result := TempStr;
end;

function HexToBinBytes(HexStr: String): TBytes;
var
 TempStr: String;
 I: Integer;
 B: TArray<Byte>;
begin
 SetLength(Result, 32);
 HexToBin(PChar(HexStr), PAnsiChar(@Result[0]), Length(Result));
end;

function GenerateNonce: String;
begin
 Randomize;
 Result := THash.GetRandomString(RandomRange(16, 24));
 Result := THashSHA1.GetHMAC(Result, Result);
end;

function BytesToString(const Value: TBytes): WideString;
begin
  SetLength(Result, Length(Value) div SizeOf(WideChar));
  if Length(Result) > 0 then
    Move(Value[0], Result[1], Length(Value));
end;

function GenerateHMAC(var Data: TAuthorizationInfo): Boolean;
var
 DataString: String;
 SKeyBytes: TArray<Byte>;
begin
 Result := True;

 if (Data.APIKey = '') or (Data.BearerToken = '') or (Data.SigningKey = '') then
  begin
   Result := False;
   Exit;
  end;

 if Data.TimeStamp = '' then
  Data.TimeStamp := DateToISO8601(TTimeZone.Local.ToUniversalTime(Now), True);

 if Data.Nonce = '' then
  Data.Nonce := GenerateNonce;

 DataString := Data.APIKey + Data.BearerToken + Data.TimeStamp + Data.Nonce;
 try
  SKeyBytes := HexToBinBytes(Data.SigningKey);
  Data.HMAC := CalculateHMACSHA256(DataString, TIdBytes(SKeyBytes));
 except
  on E:Exception do
   Result := False;
 end;
end;

end.
