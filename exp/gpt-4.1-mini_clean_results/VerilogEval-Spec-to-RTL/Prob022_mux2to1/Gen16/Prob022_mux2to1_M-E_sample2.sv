// TopModule: 1-bit 2-to-1 Multiplexer
// Implemented using basic Boolean operations: AND, OR, and NOT gates.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;

not u_not_sel(sel_n, sel);    // sel_n = ~sel
wire and0, and1;

and u_and0(and0, sel_n, a);   // and0 = ~sel & a
and u_and1(and1, sel, b);     // and1 = sel & b

or  u_or(out, and0, and1);    // out = and0 | and1

endmodule