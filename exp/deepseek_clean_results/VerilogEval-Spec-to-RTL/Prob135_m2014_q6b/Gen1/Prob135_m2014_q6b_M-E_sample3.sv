module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    // Next-state logic for y[1]
    reg next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;        // A -> A (0) or B (0)
            3'b001: next_y1 = w;        // B -> C (0) or D (1)
            3'b010: next_y1 = w;        // C -> E (0) or D (1)
            3'b011: next_y1 = ~w;       // D -> F (1) or A (0)
            3'b100: next_y1 = ~w;       // E -> E (1) or D (0)
            3'b101: next_y1 = w;        // F -> C (0) or D (1)
            default: next_y1 = 0;       // Handle undefined states
        endcase
    end

    // Output assignment
    assign Y1 = y[1];

endmodule