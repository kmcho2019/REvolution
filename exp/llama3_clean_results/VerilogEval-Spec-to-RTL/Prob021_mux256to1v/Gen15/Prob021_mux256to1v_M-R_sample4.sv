module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the start index of the 64-bit group
    wire [9:0] group_start_index = {sel[7:4], 6'd0};

    // Calculate the offset within the 64-bit group
    wire [5:0] group_offset = sel[3:0] * 4;

    // Calculate the start index of the 4-bit group within the 1024-bit input vector
    wire [9:0] out_start_index = group_start_index + group_offset;

    // Assign the output
    assign out = in[out_start_index +: 4];

endmodule