module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

wire nsel, a_and_nsel, b_and_sel;

not (nsel, sel);
and (a_and_nsel, a, nsel);
and (b_and_sel, b, sel);
or  (out, a_and_nsel, b_and_sel);

endmodule