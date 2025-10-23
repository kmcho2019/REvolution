// TopModule: 1-bit 2-to-1 Multiplexer implemented structurally using gates
// Implements: out = (~sel & a) | (sel & b)

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire not_sel;
wire and0_out, and1_out;

not U_NOT_SEL(not_sel, sel);
and U_AND0(and0_out, a, not_sel);
and U_AND1(and1_out, b, sel);
or  U_OR(out, and0_out, and1_out);

endmodule