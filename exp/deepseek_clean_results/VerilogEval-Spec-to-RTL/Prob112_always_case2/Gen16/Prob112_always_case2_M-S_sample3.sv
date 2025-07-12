module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b???1: pos = 2'b00;  // Bit 0 is set
        4'b??10: pos = 2'b01;  // Bit 1 is set
        4'b?100: pos = 2'b10;  // Bit 2 is set
        4'b1000: pos = 2'b11;  // Bit 3 is set
        default: pos = 2'b00;   // No bits set
    endcase
end

endmodule