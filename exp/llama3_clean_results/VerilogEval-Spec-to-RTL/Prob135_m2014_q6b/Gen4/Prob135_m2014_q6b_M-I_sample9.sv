module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    // Next-state logic for y[1]
    always @(*) begin
        case (y)
            3'b000: Y1 = ~w; // State A
            3'b001: Y1 = ~w; // State B
            3'b010: Y1 = w;  // State C
            3'b011: Y1 = w;  // State D
            3'b100: Y1 = w;  // State E
            3'b101: Y1 = ~w; // State F
            default: Y1 = 1'b0; // Default state
        endcase
    end
endmodule