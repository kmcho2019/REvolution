module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index of the group and the offset within the group
wire [3:0] group_index = sel[7:4];
wire [3:0] group_offset = sel[3:0];

// Calculate the output based on the group index and offset
assign out = in[(group_index * 64) + (group_offset * 4) +: 4];

endmodule