module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index of the selected 4-bit value
wire [10:0] start_idx = {sel[7:4], sel[3:0]} * 4;

// Assign the selected 4-bit value to the output
assign out = in[start_idx +: 4];

endmodule