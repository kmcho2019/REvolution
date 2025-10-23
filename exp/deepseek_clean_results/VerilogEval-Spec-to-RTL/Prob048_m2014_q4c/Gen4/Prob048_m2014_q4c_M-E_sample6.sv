module TopModule (
    input clk,
    input d,
    input r,
    output q
);

wire not_r;
wire d_muxed;

// Invert reset for mux control
not inv1 (not_r, r);

// Create reset mux functionality using AND gates
and and1 (d_muxed, d, not_r);

// Instantiate D flip-flop primitive
DFF dff_inst (
    .D(d_muxed),
    .CLK(clk),
    .Q(q)
);

endmodule