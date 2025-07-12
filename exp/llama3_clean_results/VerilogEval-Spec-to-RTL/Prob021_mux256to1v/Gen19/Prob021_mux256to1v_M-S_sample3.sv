module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the start index of the selected 4-bit block
wire [9:0] start_idx = sel * 4;

// Assign the selected 4-bit block to the output
assign out = in[start_idx +: 4];

endmodule