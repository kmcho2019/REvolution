module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Intermediate parity of first pair (a,b)
wire ab_parity;
assign ab_parity = a ^ b;

// Intermediate parity of second pair (c,d)
wire cd_parity;
assign cd_parity = c ^ d;

// Final output: even parity means inverted XOR of these intermediate parities
assign q = ~(ab_parity ^ cd_parity);

endmodule