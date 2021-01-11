unit uClientController;

interface

uses System.Classes, uClient;

type
  TClientController = class (TClientBase)
    private
      FClientModel : TClient;
      FListClient : TList;
      procedure ClearList;
    public
      constructor Create(aSender: TComponent); overload;
      destructor Destroy(); override;
      function GetProduct(aIndex: integer): TClient;
      function Open(): TClientController;
      function Count(): integer;
  end;

implementation

{ TClientController }

procedure TClientController.ClearList;
var
  I: Integer;
begin
  for I := 0 to FListClient.Count-1 do
    TList(FListClient[I]).Free;
end;

function TClientController.Count: integer;
begin
  if not Assigned(FListClient) then
    FListClient := TList.Create;
  Result := FListClient.Count;
end;

constructor TClientController.Create(aSender: TComponent);
begin
  FClientModel := TClient.Create(self);
  FListClient := TList.Create;
  Filter := TFilterClient.Create;
  inherited Create(aSender);
end;

destructor TClientController.Destroy;
begin
  if Assigned(FListClient) then
  begin
    ClearList;
    FListClient.Free;
  end;
  Filter.Free;
  inherited;
end;

function TClientController.GetProduct(aIndex: integer): TClient;
begin
  if not Assigned(FListClient) then
    FListClient := TList.Create;
  if (aIndex < 0) or (FListClient.Count-1 < aIndex) then
  begin
    Result := nil;
    exit;
  end;
  result := TClient(FListClient[aIndex]);
end;

function TClientController.Open: TClientController;
begin
  if Assigned(FListClient) then
  begin
    ClearList;
    FListClient.Free;
  end;
  FClientModel.Filter := Self.Filter;
  FListClient := FClientModel.Get;
end;

end.
