module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Calculate out_both
assign out_both[99] = 1'b0;  // Most significant bit has no neighbor to the left
assign out_both[98:0] = in[98:0] & {in[99], in[99:1]};  // Perform bitwise AND with neighbor to the left

// Calculate out_any
assign out_any[0] = 1'b0;  // Least significant bit has no neighbor to the right
assign out_any[99:1] = in[99:1] | {in[0], in[98:1]};  // Perform bitwise OR with neighbor to the right

// Calculate out_different
assign out_different = in ^ {in[0], in[99:1]};  // Perform bitwise XOR with neighbor to the left (wrap-around)

endmodule