module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    wire xor_abcd;
    assign xor_abcd = a ^ b ^ c ^ d;

    always @(*) begin
        q = ~xor_abcd;
    end
endmodule