unit uProduct;

interface

uses System.Classes;

type
  TProductBase = class(TComponent)
    type
      TFilterProduct = class
      private
        FCodigo: integer;
        FDescricao: string;
        procedure SetCodigo(const Value: integer);
        procedure SetDescricao(const Value: string);
      published
        property  Descricao : string read FDescricao write SetDescricao;
        property  Codigo : integer read FCodigo write SetCodigo;
      public
        procedure Clear;
      end;
  private
    FFilter: TFilterProduct;
    procedure SetFilter(const Value: TFilterProduct);
  published
    property Filter : TFilterProduct read FFilter write SetFilter;
  end;

  TProduct = class(TProductBase)
  private
    Fcodigo: Integer;
    Fdescricao: String;
    Fpreco: Currency;
  public
    function SetCodigo(aCodigo: Integer): TProduct;
    function SetDescricao(aDescricao: String): TProduct;
    function SetPreco(aPreco: Currency): TProduct;
    function GetCodigo: Integer;
    function GetDescricao: String;
    function GetPreco: Currency;
    function Get: TList;
  end;

implementation

uses FireDAC.Comp.Client, FireDAC.Dapt, uDM, System.SysUtils;

{ TProduct }

function TProduct.Get: TList;
var
  lQuery: TFDQuery;
  lBegin: boolean;
  lList : TList;
  lProduct : TProduct;
begin
  lBegin := True;
  lQuery := TFDQuery.Create(self);
  lQuery.Connection := DM.FDConnection;
  lQuery.Close;
  lQuery.SQL.add('SELECT codigo, descricao, preco FROM produtos');
  //Identifica se é para trazer todos os registros
  if (Filter.Codigo <> 0) or (Filter.Descricao <> '') then
  begin
    lQuery.SQL.add('WHERE');
    if Filter.Codigo <> 0 then
    begin
      lQuery.SQL.add('codigo = '+IntToStr(Filter.Codigo));
      lBegin := False;
    end;
    if Filter.Descricao <> '' then
    begin
      {Junto com as condicionais não encadeadas, possibilitam utilizar vários
      filtros ao mesmo tempo, caso necessario}
      if NOT lBegin then lQuery.SQL.add('OR');
      lQuery.SQL.add('UPPER(descricao) like '+QuotedStr('%'+UpperCase(Filter.Descricao)+'%'));
    end;
  end;
  lQuery.Open();
  if lQuery.RecordCount > 0 then
  begin
    lList := TList.Create;
    while not lQuery.Eof do
    begin
      lProduct := TProduct.Create(self);
      lProduct.Fcodigo := lQuery.FieldByName('codigo').AsInteger;
      lProduct.Fdescricao := lQuery.FieldByName('descricao').AsString;
      lProduct.Fpreco := lQuery.FieldByName('preco').AsCurrency;
      lList.Add(lProduct);
      lQuery.Next;
    end;
    Result := lList;
  end else
  begin
    Result := nil;
  end;
end;

function TProduct.GetCodigo: Integer;
begin
  result := Fcodigo;
end;

function TProduct.GetDescricao: String;
begin
  result := Fdescricao;
end;

function TProduct.GetPreco: Currency;
begin
  result := Fpreco;
end;

function TProduct.SetCodigo(aCodigo: Integer): TProduct;
begin
  Result := Self;
  Fcodigo := aCodigo;
end;

function TProduct.SetDescricao(aDescricao: String): TProduct;
begin
  Result := Self;
  Fdescricao := aDescricao;
end;

function TProduct.SetPreco(aPreco: Currency): TProduct;
begin
  Result := Self;
  Fpreco := aPreco;
end;

{ TProductBase }

procedure TProductBase.SetFilter(const Value: TFilterProduct);
begin
  FFilter := Value;
end;

{ TProductBase.TFilterProduct }

procedure TProductBase.TFilterProduct.Clear;
begin
  FCodigo := 0;
  FDescricao := '';
end;

procedure TProductBase.TFilterProduct.SetCodigo(const Value: integer);
begin
  FCodigo := Value;
end;

procedure TProductBase.TFilterProduct.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

end.
