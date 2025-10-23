module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: // State A
            if (~w) Y1 = 1'b1; // A (0) --> B
            else Y1 = 1'b0; // A (0) --> A
        3'b001: // State B
            if (~w) Y1 = 1'b0; // B (0) --> C
            else Y1 = 1'b1; // B (0) --> D
        3'b010: // State C
            if (~w) Y1 = 1'b0; // C (0) --> E
            else Y1 = 1'b1; // C (0) --> D
        3'b011: // State D
            if (~w) Y1 = 1'b1; // D (0) --> F
            else Y1 = 1'b0; // D (0) --> A
        3'b100: // State E
            if (w) Y1 = 1'b0; // E (1) --> E
            else Y1 = 1'b1; // E (1) --> D
        3'b101: // State F
            if (w) Y1 = 1'b0; // F (1) --> C
            else Y1 = 1'b1; // F (1) --> D
        default: Y1 = 1'b0;
    endcase
end

endmodule