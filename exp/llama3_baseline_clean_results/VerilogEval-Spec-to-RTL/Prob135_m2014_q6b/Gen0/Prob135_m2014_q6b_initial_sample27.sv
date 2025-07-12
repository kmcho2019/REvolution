module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

always @(y or w)
begin
    case (y)
        3'b000: Y1 = w; // A
        3'b001: Y1 = ~w; // B
        3'b010: Y1 = ~w; // C
        3'b011: Y1 = 1'b1; // D
        3'b100: Y1 = w; // E
        3'b101: Y1 = ~w; // F
        default: Y1 = 1'bx;
    endcase
end

endmodule