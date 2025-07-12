module TopModule(
    input  [3:0] in,
    output [1:0] pos
);

always @(*) begin
    casez(in)
        4'b1000: pos = 2'b01;
        4'b0100: pos = 2'b10;
        4'b0010: pos = 2'b11;
        4'b0001: pos = 2'b00; // Note: 2'b00 is the output when the first '1' is at the least significant bit position (which is the 4th position)
        default: pos = 2'b00; // Output 2'b00 when none of the input bits are '1'
    endcase
end

endmodule