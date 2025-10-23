module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*)
begin
    casez (in)
        4'b1000: pos = 2'b01;
        4'b0100: pos = 2'b10;
        4'b0010: pos = 2'b11;
        4'b0001: pos = 2'b00; // Note: pos is 2 bits so 4 (in decimal) would be 2'b100, but we are limited to 2 bits so we use 2'b00 to represent the least significant bit
        default: pos = 2'b00; // If none of the input bits are high, output zero
    endcase
end

endmodule