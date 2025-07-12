module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    // Directly implement the next-state logic for y[1] based on the state machine transitions
    always @(y, w) begin
        case (y)
            3'b000: Y1 = w ? 0 : 0; // State A
            3'b001: Y1 = w ? 1 : 1; // State B
            3'b010: Y1 = w ? 1 : 1; // State C
            3'b011: Y1 = w ? 0 : 1; // State D
            3'b100: Y1 = w ? 1 : 1; // State E
            3'b101: Y1 = w ? 1 : 1; // State F
            default: Y1 = 1'bx; // Unknown state, assign don't care
        endcase
    end

endmodule