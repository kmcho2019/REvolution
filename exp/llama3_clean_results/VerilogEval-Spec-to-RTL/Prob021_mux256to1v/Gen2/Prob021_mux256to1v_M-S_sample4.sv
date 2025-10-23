module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Assign the selected 4-bit input to the output
assign out = in[(sel << 2) +: 4];

endmodule