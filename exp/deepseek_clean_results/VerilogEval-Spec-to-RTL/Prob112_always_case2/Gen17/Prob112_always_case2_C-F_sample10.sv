module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    case (in & -in)  // Isolate rightmost 1-bit using two's complement trick
        4'b0001: pos = 2'b00;  // Bit 0 is set
        4'b0010: pos = 2'b01;  // Bit 1 is set
        4'b0100: pos = 2'b10;  // Bit 2 is set
        4'b1000: pos = 2'b11;  // Bit 3 is set
        default:  pos = 2'b00;  // All zeros case (or invalid pattern)
    endcase
end

endmodule