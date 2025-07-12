module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);

    // Intermediate signals for partial OR logic
    wire ab_or;
    wire cd_or;

    // OR of inputs a and b
    assign ab_or = a | b;

    // OR of inputs c and d
    assign cd_or = c | d;

    // Output q is high only if both ab_or and cd_or are high
    assign q = ab_or & cd_or;

endmodule