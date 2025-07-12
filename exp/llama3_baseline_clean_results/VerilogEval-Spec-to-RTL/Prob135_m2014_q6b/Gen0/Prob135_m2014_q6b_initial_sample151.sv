module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: Y1 = w ? 0 : 0; // State A
        3'b001: Y1 = w ? 0 : 0; // State B
        3'b010: Y1 = w ? 0 : 1; // State C
        3'b011: Y1 = w ? 0 : 0; // State D
        3'b100: Y1 = w ? 0 : 1; // State E
        3'b101: Y1 = w ? 0 : 0; // State F
        default: Y1 = 1'bx; // Invalid state
    endcase
end

endmodule