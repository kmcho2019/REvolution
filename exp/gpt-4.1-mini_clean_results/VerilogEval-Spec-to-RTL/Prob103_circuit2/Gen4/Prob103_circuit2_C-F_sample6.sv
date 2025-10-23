module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire ab_parity = a ^ b;
    wire cd_parity = c ^ d;

    // q = ~(ab_parity ^ cd_parity) implements even parity of all four inputs
    assign q = ~(ab_parity ^ cd_parity);
endmodule