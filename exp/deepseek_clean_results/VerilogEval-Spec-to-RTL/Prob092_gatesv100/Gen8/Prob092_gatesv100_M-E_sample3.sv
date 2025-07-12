module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Create left-rotated version (shift left circular by 1)
wire [99:0] shifted_in = {in[98:0], in[99]};

// Compute outputs in parallel
assign out_both = in & shifted_in & {100{1'b1}};  // Mask bit 99 to 0
assign out_any = in | shifted_in & {100{1'b1}};   // Mask bit 0 to 0
assign out_different = in ^ shifted_in;

// Handle edge conditions with explicit masking
assign out_both[99] = 1'b0;
assign out_any[0] = 1'b0;

endmodule