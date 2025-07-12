module TopModule(
    input  [3:0] in,  // 4-bit input
    output [1:0] pos  // 2-bit position output
);

always @(*) begin
    casez(in)
        4'b1000: pos = 2'b00; // First bit is high, so position is 0
        4'b0100: pos = 2'b01; // Second bit is high, so position is 1
        4'b0010: pos = 2'b10; // Third bit is high, so position is 2
        4'b0001: pos = 2'b11; // Fourth bit is high, so position is 3
        default: pos = 2'b00; // No bits are high, so position is 0
    endcase
end

endmodule