module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    // Optimal half-adder implementation using continuous assignments
    // This will synthesize to minimal XOR and AND gates in any technology
    assign {cout, sum} = a + b;

endmodule