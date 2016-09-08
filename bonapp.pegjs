File
  = head:PageHeader _ table:Table _
  { return {info: head, data: table} }

PageHeader "Page Header"
  = _ "MEALPLANTRANLEDG.TRANDATE in" _ from:DateTime _ "to" _ to:DateTime
  { return {from, to} }

DateTime
  = "DateTime("
    year:Integer cs
    month:Integer cs
    day:Integer cs
    hour:Integer cs
    minute:Integer cs
    second:Integer ")"
  { return {year, month, day, hour, minute, second} }

Table
  = header:TableHeader _ body:TableBody
  { return body }

TableHeader
  = _ "Stav Ha STO GUI STO Mic  Total"
  / _ "STO GUI STO Mic  Total"
  / _ "STO Mic  Total"

TableBody
  = TableRow+

TableRow
  = _ row:(BasicRow / SummaryRow / PeriodSummaryRow / GrandTotalRow) _
  { return row }

BasicRow "Basic Row"
  = data:DataColumns
  { return {type: 'basic', data} }

DataColumns "Data Columns"
  = mic:Number _ total:Number !([ \t]+ Number)
  { return {mic, total} }
  / gui:Number _ mic:Number _ total:Number !([ \t]+ Number)
  { return {gui, mic, total} }
  / stav:Number _ gui:Number _ mic:Number _ total:Number
  { return {stav, gui, mic, total} }

SummaryRow
  = ("Meal Period"?) _ time:Time _ data:DataColumns
  { return {type: 'summary', time, data} }

Time
  = hour:Integer ":"
    minute:Integer ":"
    rest:( second:Integer meridiam:("AM" / "PM") { return second + " " + meridiam }
    / "Group" { return "" } )
  { return hour + ":" + minute + (rest ? ":" + rest : "") }

PeriodSummaryRow "Period Summary Row"
  = num:(Integer / "?") _ "--" _ title:PeriodTitle _ "Total" _ data:DataColumns
  { return {type: 'period', num, title, data} }

GrandTotalRow "Grand Total Row"
  = "Grand Total" _ data:DataColumns
  { return {type: 'total', data} }

PeriodTitle
  = "*UNKNOW"
  / "Breakfa"
  / "Brunch"
  / "Lunch"
  / "Dinner"

String
  = text:[a-zA-Z*]+
  { return text.join('') }

Number "number"
  = text:[0-9,]+
  { return parseInt(text.filter(ch => ch !== ',').join(''), 10) }


Integer "integer"
  = text:[0-9]+
  { return parseInt(text.join(''), 10) }

cs "comma-space"
  = ", "

_ "whitespace"
  = [ \t\n\r]*

