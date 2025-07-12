module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the offset for the 64-bit group
    wire [9:0] group_offset;
    assign group_offset = {5'd0, sel[7:4]} * 64;

    // Calculate the offset for the 4-bit subgroup within the 64-bit group
    wire [5:0] subgroup_offset;
    assign subgroup_offset = sel[3:0] * 4;

    // Combine the offsets to directly select the 4-bit output
    assign out = in[group_offset + subgroup_offset +: 4];

endmodule