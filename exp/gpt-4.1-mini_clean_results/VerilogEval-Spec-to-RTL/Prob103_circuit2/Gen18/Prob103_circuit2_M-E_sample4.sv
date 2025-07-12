module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire xnor_ab, xnor_cd;

    assign xnor_ab = ~(a ^ b);   // XNOR of a and b
    assign xnor_cd = ~(c ^ d);   // XNOR of c and d

    assign q = ~(xnor_ab ^ xnor_cd); // Final XNOR to get even parity

endmodule