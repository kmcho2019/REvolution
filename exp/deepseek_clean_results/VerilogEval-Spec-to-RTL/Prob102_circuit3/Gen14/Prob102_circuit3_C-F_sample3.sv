module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Intermediate signals using bitwise OR for efficiency
    wire ab_or = a | b;
    wire cd_or = c | d;

    // Final output using logical AND
    assign q = ab_or & cd_or;

endmodule