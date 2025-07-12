module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000, 3'b001, 3'b010, 3'b011: Y1 = w; // A, B, C, D
        3'b100: Y1 = 1'b1; // E
        3'b101: Y1 = ~w; // F
        default: Y1 = 1'b0;
    endcase
end

endmodule