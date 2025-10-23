module TopModule(
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    // Calculate the offset of the desired 4-bit input within the in vector
    assign out = in[(sel * 4) +: 4];

endmodule