module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

wire use_b = sel_b1 & sel_b2;

assign out_assign = use_b ? b : a;
assign out_always = use_b ? b : a;

endmodule