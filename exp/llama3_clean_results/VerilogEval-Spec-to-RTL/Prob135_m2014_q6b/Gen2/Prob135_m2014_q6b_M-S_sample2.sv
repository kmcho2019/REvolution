module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: Y1 = 0; // A (0) --> B, A (1) --> A
        3'b001: Y1 = ~w; // B (0) --> C, B (1) --> D
        3'b010: Y1 = ~w; // C (0) --> E, C (1) --> D
        3'b011: Y1 = ~w; // D (0) --> F, D (1) --> A
        3'b100: Y1 = w; // E (1) --> E, E (0) --> D
        3'b101: Y1 = ~w; // F (1) --> C, F (0) --> D
        default: Y1 = 0;
    endcase
end

endmodule