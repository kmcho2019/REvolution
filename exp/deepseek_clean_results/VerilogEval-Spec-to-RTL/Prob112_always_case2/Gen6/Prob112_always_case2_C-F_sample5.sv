module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez (in)
        4'b???1: pos = 2'b00;  // Any input with bit 0 set
        4'b??10: pos = 2'b01;  // Bit 1 set (and bit 0 not set)
        4'b?100: pos = 2'b10;  // Bit 2 set (and bits 1-0 not set)
        4'b1000: pos = 2'b11;  // Bit 3 set (and bits 2-0 not set)
        default: pos = 2'b00;  // All zeros case
    endcase
end

endmodule