module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Calculate the starting bit position directly
    // sel[7:4] selects which 64-bit block (0-15)
    // sel[3:0] selects which 4-bit group within the block (0-15)
    // Each block contains 16 4-bit groups (16*4=64 bits)
    // Total offset = (block_sel * 64) + (group_sel * 4)
    assign out = in[(sel[7:4] * 64 + sel[3:0] * 4) +: 4];

endmodule