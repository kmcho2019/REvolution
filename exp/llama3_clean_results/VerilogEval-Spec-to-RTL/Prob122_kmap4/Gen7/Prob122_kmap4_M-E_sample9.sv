module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Calculate the parity of a and b
wire ab_parity = a ^ b;

// Calculate the parity of c and d
wire cd_parity = c ^ d;

// Combine the parities to produce the output
assign out = ab_parity ^ cd_parity;

endmodule