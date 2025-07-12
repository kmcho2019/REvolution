module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting bit position of the desired 4-bit input
    wire [10:0] start_bit = sel * 4;

    // Extract the desired 4-bit input from the 1024-bit input vector
    assign out = in[start_bit +: 4];

endmodule