module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Define the LUT for population count
    // For each possible input (0 to 7), store the population count
    reg [1:0] lut [7:0];
    initial begin
        lut[0] = 2'b00; // Population count for input 000 is 0
        lut[1] = 2'b01; // Population count for input 001 is 1
        lut[2] = 2'b01; // Population count for input 010 is 1
        lut[3] = 2'b10; // Population count for input 011 is 2
        lut[4] = 2'b01; // Population count for input 100 is 1
        lut[5] = 2'b10; // Population count for input 101 is 2
        lut[6] = 2'b10; // Population count for input 110 is 2
        lut[7] = 2'b11; // Population count for input 111 is 3
    end

    // Use the LUT to look up the population count for the input vector
    assign out = lut[in];

endmodule