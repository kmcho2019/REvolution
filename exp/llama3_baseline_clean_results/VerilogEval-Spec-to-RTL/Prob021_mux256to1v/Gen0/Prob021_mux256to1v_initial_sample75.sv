module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the selected 4-bit input
    wire [10:0] index = sel * 4;

    // Extract the 4-bit input from the input vector and assign it to the output
    assign out = in[index +: 4];

endmodule