module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation using continuous assignment
    assign out = ~in;
endmodule