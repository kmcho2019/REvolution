module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(y, w)
begin
    case (y)
        3'b000, 3'b001: // States A and B
            Y1 = 1'b0;
        3'b010, 3'b011: // States C and D
            Y1 = 1'b1;
        3'b100, 3'b101: // States E and F
            Y1 = 1'b1;
        default: Y1 = 1'b0;
    endcase
end

endmodule