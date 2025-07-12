module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Define intermediate signals for cd conditions
    wire cd_00;
    wire cd_01;
    wire cd_11;
    wire cd_10;

    // Define intermediate signals for ab conditions
    wire ab_01;
    wire ab_10;
    wire ab_00;
    wire ab_11;

    // Assign values to cd conditions
    assign cd_00 = ~c & ~d;
    assign cd_01 = ~c & d;
    assign cd_11 = c & d;
    assign cd_10 = c & ~d;

    // Assign values to ab conditions
    assign ab_01 = ~a & b;
    assign ab_10 = a & ~b;
    assign ab_00 = ~a & ~b;
    assign ab_11 = a & b;

    // Final output condition using the intermediate signals
    assign out = (cd_00 & (ab_01 | ab_10)) |
                 (cd_01 & (ab_00 | ab_11)) |
                 (cd_11 & (ab_01 | ab_10));

endmodule