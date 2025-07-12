module TopModule (
    input  x,
    input  y,
    output reg z
);

always @(*) begin
    // z is high if x equals y (XNOR behavior)
    if (x == y)
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule