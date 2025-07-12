module TopModule (
    input  x,
    input  y,
    output reg z
);
    // Use always_comb block for combinational logic implementing z = (x ^ y) & x
    always @(*) begin
        z = (x ^ y) & x;
    end
endmodule