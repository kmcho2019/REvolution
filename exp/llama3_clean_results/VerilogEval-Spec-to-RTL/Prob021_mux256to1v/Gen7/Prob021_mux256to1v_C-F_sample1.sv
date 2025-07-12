module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    // Calculate the offset of the 4-bit group within the input vector
    assign out = in[(sel * 4) +: 4];

endmodule