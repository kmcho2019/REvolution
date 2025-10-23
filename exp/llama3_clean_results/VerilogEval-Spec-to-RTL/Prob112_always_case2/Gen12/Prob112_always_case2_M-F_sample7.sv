module TopModule(
    input  [3:0] in,  // 4-bit input vector
    output [1:0] pos  // 2-bit output to encode the position of the first '1'
);

// Use a series of conditional statements to assign the position value to pos
// based on the first '1' bit encountered in the input vector in, starting from the most significant bit
assign pos = (in[3]) ? 2'b11 :  // If the most significant bit is '1', output 11 (3 in decimal)
             (in[2]) ? 2'b10 :  // If the second bit is '1', output 10 (2 in decimal)
             (in[1]) ? 2'b01 :  // If the third bit is '1', output 01 (1 in decimal)
             (in[0]) ? 2'b00 :  // If the least significant bit is '1', output 00 (0 in decimal)
             2'b00;           // If no '1' bits are found, default to 00

endmodule