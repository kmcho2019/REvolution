module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];  // Direct output assignment

    // Next-state logic for y[1]
    reg next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;  // State A: next state is A (0) or B (0)
            3'b001: next_y1 = w ? 1'b1 : 1'b0;  // State B: next is D (1) or C (0)
            3'b010: next_y1 = w ? 1'b1 : 1'b0;  // State C: next is D (1) or E (0)
            3'b011: next_y1 = w ? 1'b0 : 1'b0;  // State D: next is A (0) or F (0)
            3'b100: next_y1 = w ? 1'b1 : 1'b0;  // State E: next is D (1) or E (0)
            3'b101: next_y1 = w ? 1'b1 : 1'b0;  // State F: next is D (1) or C (0)
            default: next_y1 = 1'b0;  // Shouldn't occur with valid inputs
        endcase
    end

endmodule