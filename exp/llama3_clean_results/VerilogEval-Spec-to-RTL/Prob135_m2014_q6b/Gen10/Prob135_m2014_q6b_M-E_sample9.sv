module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    case (y)
        3'b000: Y1 = ~w; // A (0) --0--> B, A (0) --1--> A
        3'b001: Y1 = 1;  // B (0) --0--> C, B (0) --1--> D
        3'b010: Y1 = ~w; // C (0) --0--> E, C (0) --1--> D
        3'b011: Y1 = w;  // D (0) --0--> F, D (0) --1--> A
        3'b100: Y1 = ~w; // E (1) --0--> E, E (1) --1--> D
        3'b101: Y1 = 1;  // F (1) --0--> C, F (1) --1--> D
        default: Y1 = 0;
    endcase
end

endmodule