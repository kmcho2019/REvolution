module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset into the 1024-bit vector based on the selector value
wire [9:0] offset = sel * 4;

// Directly extract the required 4-bit value from the input vector
assign out = in[(offset + 3):offset];

endmodule