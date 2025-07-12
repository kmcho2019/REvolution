module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Directly select the appropriate 16-bit group using the upper 4 bits of sel
    // Then select the specific bit using the lower 4 bits
    assign out = in[(sel[7:4] * 16) + sel[3:0]];

endmodule