module TopModule(
    input [2:0] inputs, // Combined input vector
    output f
);

// Lookup table (LUT) to store output values for each input combination
reg [0:0] lut [7:0]; // 8 entries for 2^3 input combinations

initial begin
    // Initialize LUT based on the truth table
    lut[0] = 0; // x3=0, x2=0, x1=0
    lut[1] = 0; // x3=0, x2=0, x1=1
    lut[2] = 1; // x3=0, x2=1, x1=0
    lut[3] = 1; // x3=0, x2=1, x1=1
    lut[4] = 0; // x3=1, x2=0, x1=0
    lut[5] = 1; // x3=1, x2=0, x1=1
    lut[6] = 0; // x3=1, x2=1, x1=0
    lut[7] = 1; // x3=1, x2=1, x1=1
end

// Assign output 'f' based on the LUT and input combination
assign f = lut[inputs];

endmodule