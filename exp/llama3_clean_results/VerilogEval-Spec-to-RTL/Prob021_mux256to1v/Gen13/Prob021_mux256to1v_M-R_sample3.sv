module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Calculate the index into the 1024-bit vector based on the selector
// The formula (sel * 4) calculates the starting index of the desired 4-bit value
assign out = in[(sel * 4) +: 4];

endmodule