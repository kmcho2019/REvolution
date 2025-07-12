// TopModule: 1-bit 2-to-1 Multiplexer implemented with basic gates
// out = (a AND ~sel) OR (b AND sel)

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;

// Invert sel
not u_not_sel(sel_n, sel);

// a AND NOT sel
wire a_and_sel_n;
and u_and_a(a_and_sel_n, a, sel_n);

// b AND sel
wire b_and_sel;
and u_and_b(b_and_sel, b, sel);

// OR of both terms
or u_or_out(out, a_and_sel_n, b_and_sel);

endmodule