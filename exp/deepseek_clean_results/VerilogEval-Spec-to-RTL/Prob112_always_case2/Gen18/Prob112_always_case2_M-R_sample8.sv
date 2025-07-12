module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casex (in)
        4'b1xxx: pos = 2'b11;    // Highest priority - bit 3
        4'b01xx: pos = 2'b10;    // Next priority - bit 2
        4'b001x: pos = 2'b01;    // Next priority - bit 1
        4'b0001: pos = 2'b00;    // Lowest priority - bit 0
        default: pos = 2'b00;    // All zeros case
    endcase
end

endmodule