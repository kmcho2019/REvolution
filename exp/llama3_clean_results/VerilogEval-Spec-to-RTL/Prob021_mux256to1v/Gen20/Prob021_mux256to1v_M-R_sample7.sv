module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

// Directly use the 8-bit selector to index into the 1024-bit input vector
// This approach eliminates the need for an explicit array of wires
assign out = in[{sel, 2'b00} +: 4];

endmodule