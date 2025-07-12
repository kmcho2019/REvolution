module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);

    wire [15:0] group_select;
    wire [15:0] selected_group;

    // First stage: Select one of 16 groups using upper 4 bits
    assign group_select = in >> (sel[7:4] * 16);

    // Second stage: Select one bit from the group using lower 4 bits
    assign out = group_select[sel[3:0]];

endmodule