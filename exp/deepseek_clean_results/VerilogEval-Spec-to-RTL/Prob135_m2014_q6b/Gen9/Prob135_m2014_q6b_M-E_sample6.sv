module TopModule (
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    // Next-state logic for y[1] using case statement
    wire next_y1;
    always @(*) begin
        case (y)
            3'b000: next_y1 = 1'b0;  // State A: stays A or goes to B (001)
            3'b001: next_y1 = w ? 1'b1 : 1'b0;  // State B: goes to D (011) if w=1, else C (010)
            3'b010: next_y1 = w ? 1'b1 : 1'b0;  // State C: goes to D (011) if w=1, else E (100)
            3'b011: next_y1 = w ? 1'b0 : 1'b1;  // State D: goes to A (000) if w=1, else F (101)
            3'b100: next_y1 = w ? 1'b1 : 1'b0;  // State E: stays E (100) if w=0, else D (011)
            3'b101: next_y1 = w ? 1'b1 : 1'b0;  // State F: goes to D (011) if w=1, else C (010)
            default: next_y1 = 1'b0;
        endcase
    end

endmodule