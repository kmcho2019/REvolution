module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Optimal implementation using ternary mux operator
    // Functionally equivalent to both examples but more readable
    assign f = x3 ? x1 : x2;
endmodule