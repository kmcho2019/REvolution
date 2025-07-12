module TopModule(
    input clk,
    input in,
    output out
);

reg q; // D flip-flop state
wire d; // XOR gate output

// XOR gate
assign d = in ^ q;

// D flip-flop
always @(posedge clk)
    q <= d;

// Assign output
assign out = q;

endmodule