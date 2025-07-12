// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d using a lookup table
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Define the lookup table as a 16-bit vector
    logic [15:0] lut;

    // Initialize the lookup table with the correct output values for each input combination
    initial begin
        // Input combinations and their corresponding output values
        // The output values are based on the inverse XOR of the input bits
        lut[0]  = 1'b1;  // a=0, b=0, c=0, d=0
        lut[1]  = 1'b0;  // a=0, b=0, c=0, d=1
        lut[2]  = 1'b0;  // a=0, b=0, c=1, d=0
        lut[3]  = 1'b1;  // a=0, b=0, c=1, d=1
        lut[4]  = 1'b0;  // a=0, b=1, c=0, d=0
        lut[5]  = 1'b1;  // a=0, b=1, c=0, d=1
        lut[6]  = 1'b1;  // a=0, b=1, c=1, d=0
        lut[7]  = 1'b0;  // a=0, b=1, c=1, d=1
        lut[8]  = 1'b0;  // a=1, b=0, c=0, d=0
        lut[9]  = 1'b1;  // a=1, b=0, c=0, d=1
        lut[10] = 1'b1;  // a=1, b=0, c=1, d=0
        lut[11] = 1'b0;  // a=1, b=0, c=1, d=1
        lut[12] = 1'b1;  // a=1, b=1, c=0, d=0
        lut[13] = 1'b0;  // a=1, b=1, c=0, d=1
        lut[14] = 1'b0;  // a=1, b=1, c=1, d=0
        lut[15] = 1'b1;  // a=1, b=1, c=1, d=1
    end

    // Use the lookup table to determine the output value based on the input combination
    assign q = lut[{a, b, c, d}];

endmodule