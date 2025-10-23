module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Correct next-state logic for y[1]
    wire next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;  // State A
            3'b001: next_y1 = w;      // State B
            3'b010: next_y1 = w;      // State C
            3'b011: next_y1 = ~w;     // State D
            3'b100: next_y1 = 1'b1;   // State E
            3'b101: next_y1 = w;      // State F
            default: next_y1 = 1'b0;   // Default case
        endcase
    end

endmodule