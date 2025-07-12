module TopModule(
    input  a,
    input  b,
    input  sel_b1,
    input  sel_b2,
    output out_assign,
    output out_always
);

wire selected = (sel_b1 & sel_b2) ? b : a;
assign out_assign = selected;
assign out_always = selected;

endmodule