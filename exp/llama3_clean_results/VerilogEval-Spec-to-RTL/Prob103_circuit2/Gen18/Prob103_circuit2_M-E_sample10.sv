// Novel TopModule: Implementing the logic using majority voters and XOR gates
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Majority voter for {a, b}
    wire ab_majority;
    assign ab_majority = (a & b) | (a & ~b) | (~a & b);

    // Majority voter for {c, d}
    wire cd_majority;
    assign cd_majority = (c & d) | (c & ~d) | (~c & d);

    // Combine the majority voters with XOR gates to handle exceptions
    assign q = ~(ab_majority ^ cd_majority) & ~(a & ~b);

endmodule