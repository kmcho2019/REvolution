module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);
    reg ab_xor, cd_xor;

    always @(*) begin
        ab_xor = a ^ b;
        cd_xor = c ^ d;
        out = ab_xor ^ cd_xor;
    end
endmodule