module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = w; // State A, if w = 1, stay in A, else go to B
            3'b001: Y1 = w; // State B, if w = 1, go to A, else go to C
            3'b010: Y1 = w; // State C, if w = 1, go to D, else go to E
            3'b011: Y1 = ~w; // State D, if w = 1, go to A, else go to F
            3'b100: Y1 = w; // State E, if w = 1, go to D, else stay in E
            3'b101: Y1 = w; // State F, if w = 1, go to D, else go to C
            default: Y1 = 0; // Default case, should not occur
        endcase
    end

endmodule