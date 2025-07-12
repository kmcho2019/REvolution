module TopModule(
    input a,
    input b,
    output out
);
    // Optimal NOR gate implementation - combines clarity with PPA awareness
    assign out = ~(a | b);  // Direct NOR operation for best PPA
endmodule