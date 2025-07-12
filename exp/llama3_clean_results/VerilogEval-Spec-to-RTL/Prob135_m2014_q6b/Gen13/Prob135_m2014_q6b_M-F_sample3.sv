module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 0; // State A, y[1] is always 0 in the next state
            3'b001: Y1 = ~w; // State B, y[1] is 1 if w = 0 (go to C), 0 if w = 1 (go to A)
            3'b010: Y1 = ~w; // State C, y[1] is 1 if w = 0 (go to E), 0 if w = 1 (go to D)
            3'b011: Y1 = ~w; // State D, y[1] is 1 if w = 0 (go to F), 0 if w = 1 (go to A)
            3'b100: Y1 = w; // State E, y[1] is 1 if w = 1 (stay in E), 0 if w = 0 (go to D)
            3'b101: Y1 = ~w; // State F, y[1] is 1 if w = 0 (go to C), 0 if w = 1 (go to D)
            default: Y1 = 0; // Default case, should not occur
        endcase
    end

endmodule