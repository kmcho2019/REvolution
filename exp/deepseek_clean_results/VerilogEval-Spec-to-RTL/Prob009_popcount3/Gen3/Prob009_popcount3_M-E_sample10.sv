module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // LUT implementation for 3-bit population count
    reg [1:0] popcount_lut [0:7];
    
    initial begin
        popcount_lut[3'b000] = 2'b00;
        popcount_lut[3'b001] = 2'b01;
        popcount_lut[3'b010] = 2'b01;
        popcount_lut[3'b011] = 2'b10;
        popcount_lut[3'b100] = 2'b01;
        popcount_lut[3'b101] = 2'b10;
        popcount_lut[3'b110] = 2'b10;
        popcount_lut[3'b111] = 2'b11;
    end

    assign out = popcount_lut[in];

endmodule