module TopModule(
    input  a,
    input  b,
    output out
);

    // Internal wires to hold intermediate results
    wire same_high; // Both inputs are high
    wire same_low;  // Both inputs are low

    // Check if both inputs are high
    assign same_high = a & b;

    // Check if both inputs are low
    assign same_low = ~(a | b); // Invert the result of OR operation to check for both low

    // Combine the results of same_high and same_low using OR
    assign out = same_high | same_low;

endmodule