module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Use the 8-bit selector as an index into the 1024-bit input vector
// to directly select the desired 4-bit output
assign out = in[(sel * 4) +: 4];

endmodule