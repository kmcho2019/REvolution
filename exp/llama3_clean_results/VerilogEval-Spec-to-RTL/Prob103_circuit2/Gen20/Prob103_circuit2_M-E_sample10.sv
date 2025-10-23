// Novel TopModule implementation using a lookup table (LUT)
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the lookup table (LUT) to implement the logic
    // The LUT maps each input combination to its corresponding output value
    logic [1:0] lut[0:15];  // 4-input LUT with 16 entries (2^4)

    // Initialize the LUT with the desired output values for each input combination
    initial begin
        lut[0]  = 1'b1;  // 0000 -> 1
        lut[1]  = 1'b0;  // 0001 -> 0
        lut[2]  = 1'b0;  // 0010 -> 0
        lut[3]  = 1'b1;  // 0011 -> 1
        lut[4]  = 1'b0;  // 0100 -> 0
        lut[5]  = 1'b1;  // 0101 -> 1
        lut[6]  = 1'b1;  // 0110 -> 1
        lut[7]  = 1'b0;  // 0111 -> 0
        lut[8]  = 1'b0;  // 1000 -> 0
        lut[9]  = 1'b1;  // 1001 -> 1
        lut[10] = 1'b1;  // 1010 -> 1
        lut[11] = 1'b0;  // 1011 -> 0
        lut[12] = 1'b1;  // 1100 -> 1
        lut[13] = 1'b0;  // 1101 -> 0
        lut[14] = 1'b0;  // 1110 -> 0
        lut[15] = 1'b1;  // 1111 -> 1
    end

    // Use the LUT to determine the output q based on the input combination
    assign q = lut[{a, b, c, d}];

endmodule