module TopModule(
    input  [2:0] y,
    input        w,
    output       Y1
);

assign Y1 = y[1];

always @(*) begin
    case (y)
        3'b000: Y1 = w; // A (0) --1--> A
        3'b001: Y1 = w; // B (0) --1--> D
        3'b010: Y1 = w; // C (0) --1--> D
        3'b011: Y1 = w; // D (0) --1--> A
        3'b100: Y1 = ~w; // E (1) --0--> E
        3'b101: Y1 = ~w; // F (1) --0--> C
        default: Y1 = 1'bx;
    endcase
end

endmodule