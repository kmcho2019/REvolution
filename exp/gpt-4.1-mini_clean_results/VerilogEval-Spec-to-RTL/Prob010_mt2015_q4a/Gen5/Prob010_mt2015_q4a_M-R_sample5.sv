module TopModule (
    input  x,
    input  y,
    output reg z
);
    reg xor_out;

    always @(*) begin
        xor_out = x ^ y;
        z = xor_out & x;
    end
endmodule