module TopModule(
    input  x,
    input  y,
    output reg z
);
    always @(*) begin
        if ((x & y) | (~x & ~y))
            z = 1'b1;
        else
            z = 1'b0;
    end
endmodule