module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly calculate the start index of the desired 4-bit block
// based on the sel input and use it to index into the in vector
assign out = in[(sel * 4) +: 4];

endmodule