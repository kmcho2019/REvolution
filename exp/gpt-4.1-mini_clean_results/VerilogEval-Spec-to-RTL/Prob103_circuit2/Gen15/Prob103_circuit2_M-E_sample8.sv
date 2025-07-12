module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_parity;
wire cd_parity;

// Compute parity of pairs
assign ab_parity = ~(a ^ b);
assign cd_parity = ~(c ^ d);

// Final output is parity of the two partial results
assign q = ~(ab_parity ^ cd_parity);

endmodule