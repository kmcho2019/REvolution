module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Define the LUT with the correct counts for all possible input combinations
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

    // Use the input vector as an address to access the corresponding count from the LUT
    assign out = lut[in];

endmodule