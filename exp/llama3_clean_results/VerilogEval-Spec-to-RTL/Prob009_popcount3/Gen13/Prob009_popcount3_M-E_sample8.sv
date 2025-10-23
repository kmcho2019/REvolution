module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Define a look-up table to store the population counts for all possible input combinations
    reg [1:0] lut [7:0];
    initial begin
        lut[0] = 0;  // 000
        lut[1] = 1;  // 001
        lut[2] = 1;  // 010
        lut[3] = 2;  // 011
        lut[4] = 1;  // 100
        lut[5] = 2;  // 101
        lut[6] = 2;  // 110
        lut[7] = 3;  // 111
    end

    // Use the input vector as an address to access the corresponding count from the LUT
    assign out = lut[in];

endmodule