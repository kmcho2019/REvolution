module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg q
);

    reg xnor_ab, xnor_cd;

    always @(*) begin
        xnor_ab = ~(a ^ b);   // XNOR of a and b
        xnor_cd = ~(c ^ d);   // XNOR of c and d
        q = ~(xnor_ab ^ xnor_cd); // Final XNOR to get even parity
    end

endmodule