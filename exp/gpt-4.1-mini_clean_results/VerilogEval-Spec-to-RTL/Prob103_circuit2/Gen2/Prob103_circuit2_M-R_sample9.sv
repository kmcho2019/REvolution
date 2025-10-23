module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    always @(*) begin
        reg xor_val;
        xor_val = a ^ b ^ c ^ d;
        q = ~xor_val;
    end
endmodule