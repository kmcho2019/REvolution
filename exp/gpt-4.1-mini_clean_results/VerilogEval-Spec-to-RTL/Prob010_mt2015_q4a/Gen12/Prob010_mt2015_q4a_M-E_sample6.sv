module TopModule (
    input  x,
    input  y,
    output reg z
);

    always @(*) begin
        // compute XOR of x and y, then AND with x
        z = (x ^ y) & x;
    end

endmodule