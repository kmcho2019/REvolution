module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the 4-bit data
    wire [9:0] index = {2'b0, sel} * 4;

    // Use the index to extract the 4-bit data
    assign out = in[index +: 4];

endmodule