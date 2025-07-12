module TopModule (
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

wire sel = sel_b1 && sel_b2;

assign out_assign = sel ? b : a;
assign out_always = sel ? b : a;

endmodule