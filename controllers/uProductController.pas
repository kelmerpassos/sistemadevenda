unit uProductController;

interface

uses System.Classes, uProduct;

type
  TProductController = class (TProductBase)
    private
      FProductModel : TProduct;
      FListProduct : TList;
      procedure ClearList;
    public
      constructor Create(aSender: TComponent); overload;
      destructor Destroy(); override;
      function GetProduct(aIndex: integer): TProduct;
      function Open(): TProductController;
      function Count(): integer;
  end;

implementation

{ TProductController }

procedure TProductController.ClearList;
var
  I: Integer;
begin
  for I := 0 to FListProduct.Count-1 do
    TProduct(FListProduct[I]).Free;
end;

function TProductController.Count: integer;
begin
  if not Assigned(FListProduct) then
    FListProduct := TList.Create;
  Result := FListProduct.Count;
end;

constructor TProductController.Create(aSender: TComponent);
begin
  FProductModel := TProduct.Create(self);
  FListProduct := TList.Create;
  Filter := TFilterProduct.Create;
  inherited Create(aSender);
end;

destructor TProductController.Destroy;
begin
  if Assigned(FListProduct) then
  begin
    ClearList;
    FListProduct.Free;
  end;
  Filter.Free;
  inherited;
end;

function TProductController.GetProduct(aIndex: integer): TProduct;
begin
  if not Assigned(FListProduct) then
    FListProduct := TList.Create;
  if (aIndex < 0) or (FListProduct.Count-1 < aIndex) then
  begin
    Result := nil;
    exit;
  end;
  result := TProduct(FListProduct[aIndex]);
end;

function TProductController.Open: TProductController;
begin
  if Assigned(FListProduct) then
  begin
    ClearList;
    FListProduct.Free;
  end;
  FProductModel.Filter := Self.Filter;
  FListProduct := FProductModel.Get;
end;

end.
