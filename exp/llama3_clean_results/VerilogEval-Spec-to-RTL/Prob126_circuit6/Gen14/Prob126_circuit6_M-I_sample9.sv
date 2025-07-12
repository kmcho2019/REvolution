module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Define the lookup table as a parameter for readability and ease of modification
parameter [15:0] lut[8] = {
    16'h1232, // 3'b000
    16'haee0, // 3'b001
    16'h27d4, // 3'b010
    16'h5a0e, // 3'b011
    16'h2066, // 3'b100
    16'h64ce, // 3'b101
    16'hc526, // 3'b110
    16'h2f19  // 3'b111
};

// Use the lookup table directly to minimize the number of gates and literals
assign q = lut[a];

endmodule