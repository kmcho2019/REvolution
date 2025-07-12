module TopModule(
    input  [3:0] x,
    output       f
);

wire [15:0] lut = 16'b1001010001111101; // LSB corresponds to x=0000, MSB to x=1111

assign f = lut[x];

endmodule