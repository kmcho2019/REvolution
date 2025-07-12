module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // Directly calculate the 4-bit output using the full 8-bit selector
    // Each 4-bit group is at position: sel * 4
    assign out = in[(sel * 4) +: 4];

endmodule