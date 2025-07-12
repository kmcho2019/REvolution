module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: Y1 = w; // A
        3'b001: Y1 = ~w; // B
        3'b010: Y1 = 1'b1; // C
        3'b011: Y1 = ~w; // D
        3'b100: Y1 = 1'b1; // E
        3'b101: Y1 = ~w; // F
        default: Y1 = 1'b0; // default case
    endcase
end

endmodule