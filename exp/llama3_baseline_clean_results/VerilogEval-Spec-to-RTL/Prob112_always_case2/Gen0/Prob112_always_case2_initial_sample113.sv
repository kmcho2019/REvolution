module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

    always @(in) begin
        casez (in)
            4'b1000: pos = 2'b11; // MSB is 1, so position is 3 (2'b11)
            4'b100?: pos = 2'b11; // If MSB is 1, position is 3 regardless of others
            4'b0100: pos = 2'b10; // Second MSB is 1, so position is 2 (2'b10)
            4'b010?: pos = 2'b10; // If second MSB is 1, position is 2 regardless of others
            4'b0010: pos = 2'b01; // Third MSB is 1, so position is 1 (2'b01)
            4'b001?: pos = 2'b01; // If third MSB is 1, position is 1 regardless of others
            4'b0001: pos = 2'b00; // LSB is 1, so position is 0 (2'b00)
            default: pos = 2'b00; // If none of the above conditions are met, all bits are 0, so output 0
        endcase
    end

endmodule