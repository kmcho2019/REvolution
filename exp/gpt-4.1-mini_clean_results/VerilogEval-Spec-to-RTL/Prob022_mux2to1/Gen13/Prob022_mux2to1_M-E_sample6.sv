// TopModule: 1-bit 2-to-1 Multiplexer implemented with basic gates

module TopModule (
    input wire a,
    input wire b,
    input wire sel,
    output wire out
);

wire sel_n;

// Invert sel
not u_not_sel(sel_n, sel);

// AND gates for each input gated by select signals
wire and_a, and_b;
and u_and_a(and_a, a, sel_n);
and u_and_b(and_b, b, sel);

// OR gate to combine the two inputs
or u_or_out(out, and_a, and_b);

endmodule