module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting bit position of the desired 4-bit input
    wire [10:0] start_bit = sel * 4;

    // Assign the desired 4-bit input to the output
    assign out = in[start_bit +: 4];

endmodule