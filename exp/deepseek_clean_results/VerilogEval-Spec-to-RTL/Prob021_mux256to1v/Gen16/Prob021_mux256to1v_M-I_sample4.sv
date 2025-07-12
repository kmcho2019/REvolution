module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct calculation of selected bits using hierarchical approach
    // sel[7:4] selects the group (16 possibilities)
    // sel[3:0] selects within group (16 possibilities)
    // Each group is 16*4 = 64 bits
    assign out = in[(sel[7:4]*64 + sel[3:0]*4) +: 4];

endmodule