module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000: Y1 = 0; // A stays with y[1] = 0
        3'b001: Y1 = ~w; // B's next y[1] depends on w
        3'b010: Y1 = ~w; // C's next y[1] depends on w
        3'b011: Y1 = ~w; // D's next y[1] depends on w
        3'b100: Y1 = w; // E's next y[1] is w
        3'b101: Y1 = ~w; // F's next y[1] depends on w
        default: Y1 = 0;
    endcase
end

endmodule