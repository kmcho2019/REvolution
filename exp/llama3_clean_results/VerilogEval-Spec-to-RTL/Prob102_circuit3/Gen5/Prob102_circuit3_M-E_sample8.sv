module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

logic ab_condition;
logic cd_condition;

assign ab_condition = a | b;
assign cd_condition = c | d;
assign q = ab_condition & cd_condition;

endmodule