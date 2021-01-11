unit uOrderController;

interface

uses System.Classes, uOrder, Datasnap.DBClient;

type
  TOrderController = class(TOrderBase)
    private
      FOrderModel : TOrder;
      FListOrder : TList;
      procedure ClearList;
    public
      constructor Create(aSender: TComponent); overload;
      destructor Destroy(); override;
      function GetOrder(aIndex: integer): TOrder;
      function Open(): TOrderController;
      function Count(): integer;
      function SetOrder(aCodCliente: integer; aCDOrder: TClientDataSet; aVlTot: Currency): TOrder;
      function Commit(): boolean;
  end;

implementation

{ TOrderController }

uses uDetOrder, uDM;

procedure TOrderController.ClearList;
var
  I: Integer;
begin
  for I := 0 to FListOrder.Count-1 do
    TDetOrder(FListOrder[I]).Free;
end;

function TOrderController.Commit: boolean;
var
  I, lNum: Integer;
begin
  DM.FDConnection.StartTransaction;
  try
    lNum := FOrderModel.Post;
    for I := 0 to FListOrder.Count-1 do
    begin
      TDetOrder(FListOrder[I]).GetPedido.SetNumPedido(lNum);
      TDetOrder(FListOrder[I]).Post;
    end;

    DM.FDConnection.Commit;
    Result := true;
  except
    DM.FDConnection.Rollback;
    Result := false;
  end;
end;

function TOrderController.Count: integer;
begin
  if not Assigned(FListOrder) then
    FListOrder := TList.Create;
  Result := FListOrder.Count;
end;

constructor TOrderController.Create(aSender: TComponent);
begin
  FOrderModel := TOrder.Create(self);
  FListOrder := TList.Create;
  Filter := TFilterOrder.Create;
  inherited Create(aSender);
end;

destructor TOrderController.Destroy;
begin
  if Assigned(FListOrder) then
  begin
    ClearList;
    FListOrder.Free;
  end;
  Filter.Free;
  inherited;
end;

function TOrderController.GetOrder(aIndex: integer): TOrder;
begin
  if not Assigned(FListOrder) then
    FListOrder := TList.Create;
  if (aIndex < 0) or (FListOrder.Count-1 < aIndex) then
  begin
    Result := nil;
    exit;
  end;
  result := TOrder(FListOrder[aIndex]);
end;

function TOrderController.Open: TOrderController;
begin
  if Assigned(FListOrder) then
  begin
    ClearList;
    FListOrder.Free;
  end;
  FOrderModel.Filter := Self.Filter;
  FListOrder := FOrderModel.Get;
end;

function TOrderController.SetOrder(aCodCliente: integer;
  aCDOrder: TClientDataSet; aVlTot: Currency): TOrder;
var
  lDetOrder : TDetOrder;
begin
  FOrderModel.GetCliente.SetCodigo(aCodCliente);
  FOrderModel.SetVlTot(aVlTot);
  aCDOrder.First;
  while not aCDOrder.Eof do
  begin
    lDetOrder := TDetOrder.Create(self);
    lDetOrder
        .SetQtd(aCDOrder.FieldByName('qtd').AsInteger)
        .SetVlUni(aCDOrder.FieldByName('vlUni').AsCurrency)
        .SetVlTot(aCDOrder.FieldByName('vlTot').AsCurrency)
        .GetProduto.SetCodigo(aCDOrder.FieldByName('codProd').AsInteger);
    FListOrder.Add(lDetOrder);
    aCDOrder.Next;
  end;
end;

end.
