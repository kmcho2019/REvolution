module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index of the 4-bit value within the input vector
wire [9:0] start_idx = {sel[7:4], sel[3:0]} * 4;

// Select the 4-bit value from the input vector using the calculated starting index
assign out = in[start_idx +: 4];

endmodule