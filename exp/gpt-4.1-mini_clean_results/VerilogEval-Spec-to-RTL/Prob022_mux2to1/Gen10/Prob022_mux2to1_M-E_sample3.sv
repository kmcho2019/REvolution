module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

wire not_sel;
wire and0, and1;

not u_not_sel(not_sel, sel);
and u_and0(and0, a, not_sel);
and u_and1(and1, b, sel);
or  u_or(out, and0, and1);

endmodule