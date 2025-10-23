module TopModule(
    input [3:0] in,
    output [1:0] pos
);

    always @(*)
    begin
        casez (in)
            4'b1000: pos = 2'b10; // MSB bit position is 3 (2'b10)
            4'b0100: pos = 2'b01; // Bit position is 2 (2'b01)
            4'b0010: pos = 2'b00; // Bit position is 1 (2'b00)
            4'b0001: pos = 2'b00; // LSB bit position is 0 (2'b00)
            default: pos = 2'b00; // If none of the above conditions are met, output 0
        endcase
    end

endmodule