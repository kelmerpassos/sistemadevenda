unit uUtilities;

interface

type
  TEvent = procedure of object;

  TTypeMsg = ( tMsgDNone, tMsgDInformation, tMsgDWarning, tMsgDanger,tMsgDSuccess );

  TGenericFunctions = class
    class function IsNumeric(aText:string):boolean;
  end;

implementation

{ TGenericFunctions }

class function TGenericFunctions.IsNumeric(aText: string): boolean;
var
  iValue, iCode: Integer;
begin
  val(aText, iValue, iCode);
  if iCode = 0 then
    result := true
  else
    result := false;
end;

end.
