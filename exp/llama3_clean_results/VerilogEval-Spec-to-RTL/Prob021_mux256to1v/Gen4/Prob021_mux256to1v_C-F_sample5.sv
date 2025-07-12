module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the starting index of the selected 64-bit group
    wire [9:0] group_index = sel[7:4] * 64;

    // Extract the selected 64-bit group from the input vector
    wire [63:0] group_out = in[group_index +: 64];

    // Calculate the starting index of the selected 4-bit group within the 64-bit group
    wire [5:0] sub_index = sel[3:0] * 4;

    // Extract the selected 4-bit group from the 64-bit group
    assign out = group_out[sub_index +: 4];

endmodule