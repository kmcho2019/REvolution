module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the start index of the 4-bit input
wire [11:0] start_idx = {sel[7:4], sel[3:0]} * 4;

// Select the 4-bit input from the 1024-bit input vector
assign out = in[start_idx +: 4];

endmodule