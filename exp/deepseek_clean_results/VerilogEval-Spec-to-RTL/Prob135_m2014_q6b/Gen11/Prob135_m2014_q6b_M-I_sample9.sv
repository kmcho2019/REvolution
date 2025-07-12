module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Corrected next-state logic for y[1] only
    reg next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 0;      // A -> B (y[1] stays 0)
            3'b001: next_y1 = w;      // B -> D (1) or C (0)
            3'b010: next_y1 = w;      // C -> D (1) or E (0)
            3'b011: next_y1 = ~w;     // D -> F (1) or A (0)
            3'b100: next_y1 = w;      // E -> D (1) or stay E (0)
            3'b101: next_y1 = 0;      // F -> C (0) or D (1) - but y[1] is 0 for both
            default: next_y1 = 0;     // Handle undefined states
        endcase
    end

endmodule