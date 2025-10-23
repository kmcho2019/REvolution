module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_parity = a ^ b;
    wire cd_parity = c ^ d;

    // q is 1 if both parity bits are equal, else 0
    assign q = ~(ab_parity ^ cd_parity);
endmodule