module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using case statement
    reg next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = w ? 0 : 1;  // A -> B (0) or A (0)
            3'b001: next_y1 = w ? 1 : 1;  // B -> D (1) or C (1)
            3'b010: next_y1 = w ? 1 : 0;  // C -> D (1) or E (0)
            3'b011: next_y1 = w ? 0 : 1;  // D -> A (0) or F (1)
            3'b100: next_y1 = w ? 1 : 1;  // E -> D (1) or E (1)
            3'b101: next_y1 = w ? 1 : 1;  // F -> D (1) or C (1)
            default: next_y1 = 0;
        endcase
    end

endmodule