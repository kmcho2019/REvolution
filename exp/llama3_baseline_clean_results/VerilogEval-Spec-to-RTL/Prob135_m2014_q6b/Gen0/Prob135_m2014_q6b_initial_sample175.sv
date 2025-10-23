module TopModule(
    input [2:0] y,
    input w,
    output reg Y1
);

always @(*) begin
    if ((y == 3'b001 && w) || (y == 3'b010 && w) || (y == 3'b011 && ~w) || (y == 3'b100 && w) || (y == 3'b101 && w))
        Y1 = 1'b1;
    else
        Y1 = 1'b0;
end

endmodule