module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // The input is divided into 256 4-bit chunks
    // We use the sel value to index into these chunks
    assign out = in[(sel * 4) +: 4];

endmodule