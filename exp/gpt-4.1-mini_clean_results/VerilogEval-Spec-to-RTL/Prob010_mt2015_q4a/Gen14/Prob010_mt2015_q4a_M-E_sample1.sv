module TopModule (
    input  x,
    input  y,
    output reg z
);
    always @(*) begin
        // Compute XOR first, then AND with x
        z = (x ^ y) & x;
    end
endmodule