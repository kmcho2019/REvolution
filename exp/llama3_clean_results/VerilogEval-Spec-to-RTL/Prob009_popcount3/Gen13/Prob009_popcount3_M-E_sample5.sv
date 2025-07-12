module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Define the lookup table with precomputed population counts
    reg [1:0] lut [7:0];

    // Initialize the lookup table
    initial begin
        lut[0] = 2'b00; // 000: 0 '1's
        lut[1] = 2'b01; // 001: 1 '1'
        lut[2] = 2'b01; // 010: 1 '1'
        lut[3] = 2'b10; // 011: 2 '1's
        lut[4] = 2'b01; // 100: 1 '1'
        lut[5] = 2'b10; // 101: 2 '1's
        lut[6] = 2'b10; // 110: 2 '1's
        lut[7] = 2'b11; // 111: 3 '1's
    end

    // Use the lookup table to output the population count
    assign out = lut[in];

endmodule