module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*)
begin
    case (y)
        3'b000: // State A
            Y1 = ~w; // A (0) --> B (001), A (1) --> A (000)
        3'b001: // State B
            Y1 = 1'b1; // B (0) --> C (010), B (1) --> D (011)
        3'b010: // State C
            Y1 = 1'b1; // C (0) --> E (100), C (1) --> D (011)
        3'b011: // State D
            Y1 = ~w; // D (0) --> F (101), D (1) --> A (000)
        3'b100: // State E
            Y1 = 1'b1; // E (0) --> E (100), E (1) --> D (011)
        3'b101: // State F
            Y1 = 1'b1; // F (0) --> C (010), F (1) --> D (011)
        default: Y1 = 1'b0;
    endcase
end

endmodule