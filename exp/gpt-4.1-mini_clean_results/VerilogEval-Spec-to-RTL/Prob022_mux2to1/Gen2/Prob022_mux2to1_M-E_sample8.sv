module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_n;
wire a_sel_n;
wire b_sel;

// Invert sel to get sel_n
not u_not(sel_n, sel);

// AND a with sel_n
and u_and0(a_sel_n, a, sel_n);

// AND b with sel
and u_and1(b_sel, b, sel);

// OR the two AND outputs
or  u_or0(out, a_sel_n, b_sel);

endmodule