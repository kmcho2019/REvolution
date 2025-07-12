module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case ({y, w})
        // State A (000) transitions
        4'b0000: Y1 = 1'b0; // A -> B (w = 0)
        4'b0001: Y1 = 1'b0; // A -> A (w = 1)

        // State B (001) transitions
        4'b0010: Y1 = 1'b0; // B -> C (w = 0)
        4'b0011: Y1 = 1'b1; // B -> D (w = 1)

        // State C (010) transitions
        4'b0100: Y1 = 1'b1; // C -> E (w = 0)
        4'b0101: Y1 = 1'b1; // C -> D (w = 1)

        // State D (011) transitions
        4'b0110: Y1 = 1'b1; // D -> F (w = 0)
        4'b0111: Y1 = 1'b0; // D -> A (w = 1)

        // State E (100) transitions
        4'b1000: Y1 = 1'b1; // E -> E (w = 0)
        4'b1001: Y1 = 1'b1; // E -> D (w = 1)

        // State F (101) transitions
        4'b1010: Y1 = 1'b0; // F -> C (w = 0)
        4'b1011: Y1 = 1'b1; // F -> D (w = 1)

        default: Y1 = 1'b0; // default case
    endcase
end

endmodule