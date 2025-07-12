module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(*) begin
        case(in)
            4'b1000: pos = 2'b10; // Position of the first '1' bit is 3
            4'b1001, 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111: pos = 2'b10; // If any of these combinations, first '1' bit position is 3
            4'b0100: pos = 2'b01; // Position of the first '1' bit is 2
            4'b0101, 4'b0110, 4'b0111: pos = 2'b01; // If any of these combinations, first '1' bit position is 2
            4'b0010: pos = 2'b00; // Position of the first '1' bit is 1
            4'b0011: pos = 2'b00; // If this combination, first '1' bit position is 1
            4'b0001: pos = 2'b00; // Position of the first '1' bit is 0
            default: pos = 2'b00; // If none of the above conditions are met, input is '0000', so output '00'
        endcase
    end

endmodule