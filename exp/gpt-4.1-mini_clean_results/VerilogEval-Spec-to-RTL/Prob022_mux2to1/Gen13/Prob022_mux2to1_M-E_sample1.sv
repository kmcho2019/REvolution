// TopModule: 1-bit 2-to-1 Multiplexer implemented with gate-level primitives
// out = (a AND NOT sel) OR (b AND sel)

module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

wire not_sel;
wire a_and_not_sel;
wire b_and_sel;

// Invert sel
not U_not_sel(not_sel, sel);

// AND gates
and U_and_a(a_and_not_sel, a, not_sel);
and U_and_b(b_and_sel, b, sel);

// OR gate
or U_or_out(out, a_and_not_sel, b_and_sel);

endmodule