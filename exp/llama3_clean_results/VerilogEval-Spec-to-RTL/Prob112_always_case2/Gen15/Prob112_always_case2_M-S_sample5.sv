module TopModule(
    input  [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b1000: pos = 2'b11;  // MSB (position 3)
        4'b0100: pos = 2'b10;  // Second MSB (position 2)
        4'b0010: pos = 2'b01;  // Second LSB (position 1)
        4'b0001: pos = 2'b00;  // LSB (position 0)
        default: pos = 2'b00;   // All zeros, output 0
    endcase
end

endmodule