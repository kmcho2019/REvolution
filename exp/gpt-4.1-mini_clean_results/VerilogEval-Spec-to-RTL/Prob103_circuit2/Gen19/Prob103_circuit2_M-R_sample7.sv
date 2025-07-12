module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);
    reg parity_xor;

    always @(*) begin
        parity_xor = a ^ b ^ c ^ d;
        q = ~parity_xor;
    end

endmodule