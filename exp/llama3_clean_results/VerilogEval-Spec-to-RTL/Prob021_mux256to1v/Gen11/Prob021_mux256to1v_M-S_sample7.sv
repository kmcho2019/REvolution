module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the offset of the 4-bit input within the 1024-bit input vector
assign out = in[(sel[7:4] * 64) + (sel[3:0] * 4) +: 4];

endmodule