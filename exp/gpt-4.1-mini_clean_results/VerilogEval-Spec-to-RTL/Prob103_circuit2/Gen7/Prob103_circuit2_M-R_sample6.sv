module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    always @(*) begin
        wire ab_xor = a ^ b;
        wire cd_xor = c ^ d;
        q = ~ (ab_xor ^ cd_xor);
    end

endmodule