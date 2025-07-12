// TopModule: 1-bit 2-to-1 Multiplexer using AND-OR gates
// When sel=0, out = a; when sel=1, out = b.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;
wire a_and_seln;
wire b_and_sel;

not u_not(sel_n, sel);
and u_and1(a_and_seln, a, sel_n);
and u_and2(b_and_sel, b, sel);
or  u_or(out, a_and_seln, b_and_sel);

endmodule