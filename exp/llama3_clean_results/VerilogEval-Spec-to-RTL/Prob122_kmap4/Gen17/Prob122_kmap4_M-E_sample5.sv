module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Internal wires to hold intermediate results
    wire ab_odd;
    wire cd_odd;

    // Detect odd number of 1s among a and b
    assign ab_odd = (a ^ b);

    // Detect odd number of 1s among c and d
    assign cd_odd = (c ^ d);

    // Final output is 1 if there's an odd number of 1s in both pairs or in neither
    assign out = (ab_odd ^ cd_odd);

endmodule