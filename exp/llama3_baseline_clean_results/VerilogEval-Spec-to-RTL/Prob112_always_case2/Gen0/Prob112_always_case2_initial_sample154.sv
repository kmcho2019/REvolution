module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit output representing position
);

always @(*) begin
    case(in)
        4'b1000: pos = 2'b01;  // bit 0 is the first '1'
        4'b1001, 4'b0100: pos = 2'b10;  // bit 1 is the first '1'
        4'b0010, 4'b0110, 4'b1010, 4'b1100: pos = 2'b11;  // bit 2 is the first '1'
        4'b0001, 4'b0011, 4'b0101, 4'b0111, 4'b1001, 4'b1011, 4'b1101, 4'b1111: pos = 2'b00;  // bit 3 is the first '1'
        default: pos = 2'b00;  // if none of the above cases match, output zero
    endcase
end

endmodule