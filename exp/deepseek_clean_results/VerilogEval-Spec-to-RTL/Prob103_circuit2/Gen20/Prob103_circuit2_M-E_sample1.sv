module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire parity_ab = a ^ b;
    wire parity_cd = c ^ d;
    assign q = ~(parity_ab ^ parity_cd);

endmodule