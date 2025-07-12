module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(*) begin
    // Derive logic equation for Y1 (state A)
    Y1 = (y == 6'b000001 && w == 1) || (y == 6'b001000 && w == 1);

    // Derive logic equation for Y3 (state C)
    Y3 = (y == 6'b000010 && w == 0) || (y == 6'b100000 && w == 0);
end

endmodule