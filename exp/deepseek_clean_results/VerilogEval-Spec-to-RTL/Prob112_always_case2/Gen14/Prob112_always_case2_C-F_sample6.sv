module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always @(*) begin
    casez(in)  // Use casez for priority encoding
        4'b???1: pos = 2'b00;  // Rightmost 1 is bit 0
        4'b??10: pos = 2'b01;  // Rightmost 1 is bit 1
        4'b?100: pos = 2'b10;  // Rightmost 1 is bit 2
        4'b1000: pos = 2'b11;  // Rightmost 1 is bit 3
        default: pos = 2'b00;   // All zeros case
    endcase
end

endmodule