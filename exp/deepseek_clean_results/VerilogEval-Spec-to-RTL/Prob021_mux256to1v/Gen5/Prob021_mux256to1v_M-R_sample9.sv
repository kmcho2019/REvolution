module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Direct calculation of selected 4-bit output
    // sel[7:4] selects group (0-15), sel[3:0] selects within group (0-15)
    // Each group is 16*4=64 bits, so group offset is sel[7:4]*64
    // Within group, each 4-bit word is selected by sel[3:0]*4
    assign out = in[(sel[7:4]*64 + sel[3:0]*4) +: 4];

endmodule