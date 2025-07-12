module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casex(in)
        4'b1xxx: pos = 2'b11;  // Bit 3 is first high
        4'b01xx: pos = 2'b10;   // Bit 2 is first high
        4'b001x: pos = 2'b01;   // Bit 1 is first high
        4'b0001: pos = 2'b00;   // Bit 0 is first high
        default: pos = 2'b00;   // All zeros case
    endcase
end

endmodule