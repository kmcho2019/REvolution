module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly calculate the offset for the 4-bit input within the 1024-bit vector
assign out = in[(sel * 4) +: 4];

endmodule