module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    case(in)
        4'b1000: pos = 2'b00;  // Bit 3 is the first '1' bit
        4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b00;  // Bit 3 is the first '1' bit
        4'b0100: pos = 2'b01;  // Bit 2 is the first '1' bit
        4'b0101, 4'b0110, 4'b0111: pos = 2'b01;  // Bit 2 is the first '1' bit
        4'b0010: pos = 2'b10;  // Bit 1 is the first '1' bit
        4'b0011: pos = 2'b10;  // Bit 1 is the first '1' bit
        4'b0001: pos = 2'b11;  // Bit 0 is the first '1' bit
        default: pos = 2'b00;  // No '1' bit found, output 0
    endcase
end

endmodule