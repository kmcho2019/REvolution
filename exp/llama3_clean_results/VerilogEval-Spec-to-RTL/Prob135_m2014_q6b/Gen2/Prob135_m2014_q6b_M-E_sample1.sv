module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000, 3'b001, 3'b010: // States A, B, C
            Y1 = (y == 3'b000 && w == 0) || (y == 3'b001 && w == 1) || (y == 3'b010 && w == 1)? 1'b1 : 0;
        3'b011, 3'b100, 3'b101: // States D, E, F
            Y1 = (y == 3'b011 && w == 1) || (y == 3'b100 && w == 1) || (y == 3'b101 && w == 1)? 1'b1 : 0;
        default: Y1 = 1'b0;
    endcase
end

endmodule