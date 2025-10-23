module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First stage: Select one of 16 64-bit groups
    wire [63:0] selected_group = in[sel[7:4]*64 +: 64];
    
    // Second stage: Select one 4-bit output from the selected group
    assign out = selected_group[sel[3:0]*4 +: 4];

endmodule