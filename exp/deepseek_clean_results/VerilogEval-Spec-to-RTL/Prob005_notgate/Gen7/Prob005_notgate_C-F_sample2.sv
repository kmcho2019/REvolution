module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation using direct bitwise negation
    assign out = ~in;
endmodule