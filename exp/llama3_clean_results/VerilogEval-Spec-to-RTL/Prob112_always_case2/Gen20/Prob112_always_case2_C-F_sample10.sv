module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

    // Determine the position of the first '1' bit in the input vector
    // If the least significant bit is '1', the position is 0
    // If the second least significant bit is '1' and the least significant bit is '0', the position is 1
    // If the third least significant bit is '1' and the two least significant bits are '0', the position is 2
    // If the most significant bit is '1' and the three least significant bits are '0', the position is 3
    assign pos = (in[0] ? 2'b00 : 
                 (in[1] && !in[0]) ? 2'b01 : 
                 (in[2] && !in[1] && !in[0]) ? 2'b10 : 
                 (in[3] && !in[2] && !in[1] && !in[0]) ? 2'b11 : 2'b00);

endmodule