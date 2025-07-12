module TopModule(
    input [3:0] x,  // x[3]x[4]x[1]x[2] mapping
    output f
);
    assign f = x[3] | (~x[2] & x[1] & x[0]) | (x[2] & ~x[1] & ~x[0]);
    // x[3] = x[3] (MSB)
    // x[4] = x[2] (second bit in input)
    // x[1] = x[1] (third bit in input)
    // x[2] = x[0] (LSB)
endmodule