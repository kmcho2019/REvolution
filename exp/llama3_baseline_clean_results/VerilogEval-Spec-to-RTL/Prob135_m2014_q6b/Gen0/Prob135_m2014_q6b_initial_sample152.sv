module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: Y1 = 0; // State A
        3'b001: Y1 = w; // State B
        3'b010: Y1 = w; // State C
        3'b011: Y1 = w; // State E
        3'b100: Y1 = 1; // State D
        3'b101: Y1 = 1; // State F
        default: Y1 = 0; // default case
    endcase
end

endmodule