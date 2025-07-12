module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Define the lookup table
    reg [1:0] lut [7:0];

    // Initialize the lookup table with pre-computed population counts
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

    // Use the input vector as an address to the lookup table
    assign out = lut[in];

endmodule