module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: // A
            Y1 = w ? 1'b0 : 1'b0; // Stays in A (000) regardless of w
        3'b001: // B
            Y1 = w ? 1'b0 : 1'b1; // Goes to D (011) if w=1, to C (010) if w=0
        3'b010: // C
            Y1 = w ? 1'b0 : 1'b1; // Goes to D (011) if w=1, stays in E (100) or goes to E (100) if w=0
        3'b011: // D
            Y1 = w ? 1'b0 : 1'b0; // Goes to A (000) if w=1, to F (101) if w=0
        3'b100: // E
            Y1 = w ? 1'b1 : 1'b1; // Stays in E (100) if w=1, goes to D (011) if w=0
        3'b101: // F
            Y1 = w ? 1'b1 : 1'b0; // Goes to D (011) if w=1, to C (010) if w=0
        default:
            Y1 = 1'b0; // For any other state, set Y1 to 0 by default
    endcase
end

endmodule