module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the starting index within the input vector
assign out = in[(sel * 4) +: 4];

endmodule