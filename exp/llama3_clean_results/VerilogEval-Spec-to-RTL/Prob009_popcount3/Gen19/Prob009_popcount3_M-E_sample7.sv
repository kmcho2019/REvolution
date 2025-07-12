module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Define the lookup table for population counts
    // For each 3-bit input vector, store the corresponding population count
    reg [1:0] lut [7:0];
    initial begin
        lut[0] = 2'b00; // 000
        lut[1] = 2'b01; // 001
        lut[2] = 2'b01; // 010
        lut[3] = 2'b10; // 011
        lut[4] = 2'b01; // 100
        lut[5] = 2'b10; // 101
        lut[6] = 2'b10; // 110
        lut[7] = 2'b11; // 111
    end

    // Use the lookup table to get the population count
    assign out = lut[in];

endmodule