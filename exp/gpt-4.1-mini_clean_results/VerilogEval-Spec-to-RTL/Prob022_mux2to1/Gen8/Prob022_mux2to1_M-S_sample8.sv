module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;
wire a_and_sel_n;
wire b_and_sel;

not u_not(sel_n, sel);
and u_and1(a_and_sel_n, a, sel_n);
and u_and2(b_and_sel, b, sel);
or  u_or(out, a_and_sel_n, b_and_sel);

endmodule