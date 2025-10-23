// TopModule: 1-bit 2-to-1 Multiplexer (structural gate-level implementation)
// Out = a when sel=0, and b when sel=1
// Implemented with explicit NOT, AND, and OR gates.

module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire out
);

wire sel_n;    // Inverted select

// Invert sel
not U_not_sel(sel_n, sel);

// AND gates to gate inputs by sel and sel_n
wire and_a, and_b;
and U_and_a(and_a, a, sel_n);
and U_and_b(and_b, b, sel);

// OR gate to combine gated inputs
or  U_or_out(out, and_a, and_b);

endmodule