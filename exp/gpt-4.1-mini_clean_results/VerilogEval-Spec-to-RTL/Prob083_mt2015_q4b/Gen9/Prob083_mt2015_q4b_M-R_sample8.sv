module TopModule (
    input wire x,
    input wire y,
    output reg z
);

always @(*) begin
    if ((x == 0 && y == 0) || (x == 1 && y == 1))
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule