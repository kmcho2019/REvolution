module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    // Intermediate signals for partial logic
    wire ab_or;  // Result of a OR b
    wire cd_or;  // Result of c OR d

    // Assign intermediate OR results
    assign ab_or = a | b;
    assign cd_or = c | d;

    // Final output is AND of the two intermediate OR results
    assign q = ab_or & cd_or;

endmodule