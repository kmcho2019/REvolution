module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: // State A
            Y1 = w ? 1'b0 : 1'b1; // A (0) --> B, A (1) --> A
        3'b001: // State B
            Y1 = w ? 1'b1 : 1'b0; // B (0) --> C, B (1) --> D
        3'b010: // State C
            Y1 = w ? 1'b1 : 1'b0; // C (0) --> E, C (1) --> D
        3'b011: // State D
            Y1 = w ? 1'b0 : 1'b1; // D (0) --> F, D (1) --> A
        3'b100: // State E
            Y1 = w ? 1'b0 : 1'b1; // E (1) --> E, E (0) --> D
        3'b101: // State F
            Y1 = w ? 1'b0 : 1'b1; // F (1) --> C, F (0) --> D
        default: Y1 = 1'b0;
    endcase
end

endmodule