module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

// Next state logic for y[1]
always @(y, w)
begin
    case (y)
        3'b000: Y1 <= w;  // A (0) --1--> A, A (0) --0--> B
        3'b001: Y1 <= ~w;  // B (0) --1--> D, B (0) --0--> C
        3'b010: Y1 <= 1;  // C (0) --0--> E, C (0) --1--> D
        3'b011: Y1 <= ~w;  // D (0) --1--> A, D (0) --0--> F
        3'b100: Y1 <= w;  // E (1) --0--> E, E (1) --1--> D
        3'b101: Y1 <= ~w;  // F (1) --0--> C, F (1) --1--> D
    endcase
end

endmodule