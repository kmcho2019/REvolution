module TopModule(
    input  [1023:0] in,  // 1024-bit input vector
    input  [7:0] sel,    // 8-bit select line
    output [3:0] out     // 4-bit output
);

    assign out = in[(sel * 4) +: 4];  // Select 4 bits from in based on sel

endmodule