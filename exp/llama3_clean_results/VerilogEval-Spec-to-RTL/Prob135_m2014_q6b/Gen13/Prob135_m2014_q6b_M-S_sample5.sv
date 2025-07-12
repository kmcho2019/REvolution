module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

    always @(*) begin
        case (y)
            3'b000: Y1 = 1'b0; // State A transitions
            3'b001: Y1 = w; // State B transitions
            3'b010: Y1 = w; // State C transitions
            3'b011: Y1 = ~w; // State D transitions
            3'b100: Y1 = w; // State E transitions
            3'b101: Y1 = w; // State F transitions
        endcase
    end

endmodule