module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output reg A_greater,  // 1 if A is greater than B
    output reg A_equal,   // 1 if A is equal to B
    output reg A_less    // 1 if A is less than B
);

always @(*) begin
    case ({A, B})
        // A (3'b000) is less than B (all values)
        8'b00000000: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000001: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000010: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000011: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000100: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000101: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000110: {A_greater, A_equal, A_less} = 3'b001;
        8'b00000111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b001) is less than B (3'b010 to 3'b111)
        8'b00010000: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010001: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010010: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010011: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010100: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010101: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010110: {A_greater, A_equal, A_less} = 3'b001;
        8'b00010111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b010) is less than B (3'b011 to 3'b111)
        8'b00100000: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100001: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100010: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100011: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100100: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100101: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100110: {A_greater, A_equal, A_less} = 3'b001;
        8'b00100111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b011) is less than B (3'b100 to 3'b111)
        8'b00110000: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110001: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110010: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110011: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110100: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110101: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110110: {A_greater, A_equal, A_less} = 3'b001;
        8'b00110111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b100) is less than B (3'b101 to 3'b111)
        8'b01000000: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000001: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000010: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000011: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000100: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000101: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000110: {A_greater, A_equal, A_less} = 3'b001;
        8'b01000111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b101) is less than B (3'b110 to 3'b111)
        8'b01010000: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010001: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010010: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010011: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010100: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010101: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010110: {A_greater, A_equal, A_less} = 3'b001;
        8'b01010111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b110) is less than B (3'b111)
        8'b01100000: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100001: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100010: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100011: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100100: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100101: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100110: {A_greater, A_equal, A_less} = 3'b001;
        8'b01100111: {A_greater, A_equal, A_less} = 3'b001;
        
        // A (3'b111) is greater than all B
        default: {A_greater, A_equal, A_less} = 3'b100;
    endcase
end

endmodule