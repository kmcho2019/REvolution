module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_odd; // Indicates if (a, b) has an odd number of 1s
    wire cd_odd; // Indicates if (c, d) has an odd number of 1s

    // Determine if (a, b) has an odd number of 1s
    assign ab_odd = (a ^ b);

    // Determine if (c, d) has an odd number of 1s
    assign cd_odd = (c ^ d);

    // The final output is 1 if exactly one of the pairs has an odd number of 1s
    assign out = (ab_odd ^ cd_odd);

endmodule