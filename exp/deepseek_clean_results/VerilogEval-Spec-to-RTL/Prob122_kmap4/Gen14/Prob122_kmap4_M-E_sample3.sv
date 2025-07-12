module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire ab_parity = a ^ b;
    wire cd_parity = c ^ d;
    assign out = ~(ab_parity ^ cd_parity);

endmodule