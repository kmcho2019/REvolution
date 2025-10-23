module TopModule(
    input [2:0] a,
    output [15:0] q
);

// Define an array of output values corresponding to each possible input value of 'a'
reg [15:0] lut [7:0] = {
    16'h1232, // For a = 3'b000
    16'haee0, // For a = 3'b001
    16'h27d4, // For a = 3'b010
    16'h5a0e, // For a = 3'b011
    16'h2066, // For a = 3'b100
    16'h64ce, // For a = 3'b101
    16'hc526, // For a = 3'b110
    16'h2f19  // For a = 3'b111
};

// Use the lookup table to assign the output 'q' based on the input 'a'
assign q = lut[a];

endmodule