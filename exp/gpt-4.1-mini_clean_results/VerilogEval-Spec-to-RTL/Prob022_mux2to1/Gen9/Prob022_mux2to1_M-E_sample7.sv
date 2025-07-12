module TopModule(
    input a,
    input b,
    input sel,
    output out
);

wire sel_n;
wire a_sel;
wire b_sel;

not u_not(sel_n, sel);
and u_and1(a_sel, a, sel_n);
and u_and2(b_sel, b, sel);
or  u_or(out, a_sel, b_sel);

endmodule