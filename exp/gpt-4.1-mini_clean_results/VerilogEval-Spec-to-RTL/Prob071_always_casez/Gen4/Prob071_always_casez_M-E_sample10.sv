module TopModule (
    input  [7:0] in,
    output [2:0] pos
);
    wire [7:0] one_hot;
    // Isolate least significant set bit (LSB)
    assign one_hot = in & (~in + 8'b1);

    // Convert one_hot to binary position
    // pos[0] = 1 if bit 1,3,5,7 is set in one_hot
    // pos[1] = 1 if bit 2,3,6,7
    // pos[2] = 1 if bit 4,5,6,7
    assign pos[0] = |(one_hot & 8'b10101010); // bits 1,3,5,7
    assign pos[1] = |(one_hot & 8'b11001100); // bits 2,3,6,7
    assign pos[2] = |(one_hot & 8'b11110000); // bits 4,5,6,7

    // If no bits set in input, output zero by overriding pos
    wire no_bit_set = (in == 8'b0);
    assign pos = no_bit_set ? 3'b000 : pos;

endmodule