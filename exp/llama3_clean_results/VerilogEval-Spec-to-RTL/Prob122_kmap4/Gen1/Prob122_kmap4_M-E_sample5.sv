module TopModule(
    input  [3:0] in,  // 4-bit input vector: abcd
    output out
);

// Define the LUT based on the Karnaugh map
reg [15:0] lut = 16'b0001000101001001;

// Use the input vector to index into the LUT and assign the output
assign out = lut[in];

endmodule