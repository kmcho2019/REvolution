module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // LUT implementation for population count
    reg [1:0] popcount_lut [0:7];
    
    initial begin
        popcount_lut[0] = 2'b00;  // 000
        popcount_lut[1] = 2'b01;  // 001
        popcount_lut[2] = 2'b01;  // 010
        popcount_lut[3] = 2'b10;  // 011
        popcount_lut[4] = 2'b01;  // 100
        popcount_lut[5] = 2'b10;  // 101
        popcount_lut[6] = 2'b10;  // 110
        popcount_lut[7] = 2'b11;  // 111
    end

    assign out = popcount_lut[in];

endmodule