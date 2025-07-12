module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // First level: Select one of 16 16-bit groups
    wire [15:0] selected_group;
    assign selected_group = in[(sel[7:4]*16)+15 -:16];

    // Second level: Select one bit from the selected group
    assign out = selected_group[sel[3:0]];

endmodule