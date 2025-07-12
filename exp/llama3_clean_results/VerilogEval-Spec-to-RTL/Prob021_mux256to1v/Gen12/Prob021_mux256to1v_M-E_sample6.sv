module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Use the 8-bit selector as an address to access the desired 4-bit word
assign out = in[(sel * 4) +: 4];

endmodule