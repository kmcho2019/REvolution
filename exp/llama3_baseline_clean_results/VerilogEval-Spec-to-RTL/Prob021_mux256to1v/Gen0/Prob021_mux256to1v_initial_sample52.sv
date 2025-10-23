module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the 4-bit input
    wire [9:0] start_idx = sel * 4;

    // Extract the correct 4-bit input and assign it to the output
    assign out = in[start_idx +: 4];

endmodule