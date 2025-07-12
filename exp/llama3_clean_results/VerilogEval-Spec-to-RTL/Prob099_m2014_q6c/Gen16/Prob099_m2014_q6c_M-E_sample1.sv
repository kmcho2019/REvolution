module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

reg Y2, Y4;

always @(*) begin
    // Derive logic equation for Y2 (state B)
    Y2 = (y == 6'b000001 && w == 0) || (y == 6'b000100 && w == 0) || (y == 6'b001000 && w == 0);

    // Derive logic equation for Y4 (state D)
    Y4 = (y == 6'b000010 && w == 1) || (y == 6'b000100 && w == 1) || (y == 6'b010000 && w == 0);

    // Assign output signals
    Y1 = (y == 6'b000001);
    Y3 = (y == 6'b000100);
end

endmodule