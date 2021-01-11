unit uOrder;

interface

uses System.Classes, uClient;

type
  TOrderBase = class(TComponent)
    type
      TFilterOrder = class
      private
        FNomeCliente: string;
        FNumero: integer;
        procedure SetNumero(const Value: integer);
        procedure SetNomeCliente(const Value: string);
      published
        property  NomeCliente: string read FNomeCliente write SetNomeCliente;
        property  Numero : integer read FNumero write SetNumero;
      public
        procedure Clear;
      end;
  private
    FFilter: TFilterOrder;
    procedure SetFilter(const Value: TFilterOrder);
  published
    property Filter : TFilterOrder read FFilter write SetFilter;
  end;

  TOrder = class(TOrderBase)
  private
    FnumPedido : Integer;
    Fdata : TDate;
    FvlTot : Currency;
    Fprodutos : TList;
    Fcliente : TClient;

  public
    constructor Create(aSender: TComponent); overload;
    function SetNumPedido(aNumPedido: Integer): TOrder;
    function SetData(aData: Integer): TOrder;
    function SetVlTot(aVlTot: Currency): TOrder;
    function GetNumPedido: Integer;
    function GetData: TDate;
    function GetVlTot: Currency;
    function GetProdutos: TList;
    function GetCliente: TClient;
    function Get: TList;
    function Post: integer;
  end;

implementation

uses FireDAC.Comp.Client, FireDAC.Dapt, uDM, System.SysUtils, uDetOrder;

{ TOrder }

constructor TOrder.Create(aSender: TComponent);
begin
  Fcliente := TClient.Create(self);
  inherited Create(aSender);
end;

function TOrder.Get: TList;
var
  lQuery: TFDQuery;
  lBegin: boolean;
  lList : TList;
  lOrder : TOrder;
begin
  lBegin := True;
  lQuery := TFDQuery.Create(self);
  lQuery.Connection := DM.FDConnection;
  lQuery.Close;
  lQuery.SQL.add('select p.numero, p.data_emissao, p.vlTot, c.nome from pedidos as p');
  lQuery.SQL.add('inner join clientes as c on p.cod_cliente = c.codigo');
  //Identifica se é para trazer todos os registros
  if (Filter.Numero <> 0) or (Filter.NomeCliente <> '') then
  begin
    lQuery.SQL.add('WHERE');
    if Filter.Numero <> 0 then
    begin
      lQuery.SQL.add('p.numero = '+IntToStr(Filter.Numero));
      lBegin := False;
    end;
  end;
  lQuery.Open();
  if lQuery.RecordCount > 0 then
  begin
    lList := TList.Create;
    while not lQuery.Eof do
    begin
      lOrder := TOrder.Create(self);
      lOrder.FnumPedido := lQuery.FieldByName('numero').AsInteger;
      lOrder.Fdata := lQuery.FieldByName('data_emissao').AsDateTime;
      lOrder.FvlTot := lQuery.FieldByName('vlTot').AsCurrency;
      lList.Add(lOrder);
      lQuery.Next;
    end;
    Result := lList;
  end else
  begin
    Result := nil;
  end;
end;

function TOrder.GetCliente: TClient;
begin
  Result := Fcliente;
end;

function TOrder.GetData: TDate;
begin
  Result := Fdata;
end;

function TOrder.GetNumPedido: Integer;
begin
  Result := FnumPedido;
end;

function TOrder.GetProdutos: TList;
begin
  Result := Fprodutos;
end;

function TOrder.GetVlTot: Currency;
begin
  Result := FvlTot;
end;

function TOrder.Post: integer;
begin
  with DM.FDQuery do
  begin
    SQL.Clear;
    SQL.Add('insert into pedidos (data_emissao, cod_cliente, vlTot)');
    SQL.Add('values (:DATA , :COD, :VLTOT)');
    ParamByName('DATA').AsDate := Date();
    ParamByName('COD').AsInteger := GetCliente.GetCodigo;
    ParamByName('VLTOT').AsCurrency := FvlTot;
    ExecSQL;
    Close;
    SQL.Clear;
    SQL.Add('SELECT LAST_INSERT_ID() as id');
    Open();
    Result := FieldByName('id').AsInteger;
  end;
end;

function TOrder.SetData(aData: Integer): TOrder;
begin
  Result := Self;
  Fdata := aData;
end;

function TOrder.SetNumPedido(aNumPedido: Integer): TOrder;
begin
  Result := Self;
  FnumPedido := aNumPedido;
end;

function TOrder.SetVlTot(aVlTot: Currency): TOrder;
begin
  Result := Self;
  FvlTot := aVlTot;
end;

{ TOrderBase.TFilterOrder }

procedure TOrderBase.TFilterOrder.Clear;
begin
  FNomeCliente := '';
  FNumero := 0;
end;

procedure TOrderBase.TFilterOrder.SetNumero(const Value: integer);
begin
  FNumero := Value;
end;

procedure TOrderBase.TFilterOrder.SetNomeCliente(const Value: string);
begin
  FNomeCliente := Value;
end;

{ TOrderBase }

procedure TOrderBase.SetFilter(const Value: TFilterOrder);
begin
  FFilter := Value;
end;

end.
