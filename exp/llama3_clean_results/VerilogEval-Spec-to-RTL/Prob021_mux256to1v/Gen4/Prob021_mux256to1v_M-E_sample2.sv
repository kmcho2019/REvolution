module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the first bit of the desired 4-bit input
wire [9:0] index;
assign index = {2'b0, sel} * 4;

// Extract the 4-bit output from the 1024-bit input vector
assign out = in[index +: 4];

endmodule