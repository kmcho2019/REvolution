module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal implementation using bitwise operators
    assign q = (a | b) & (c | d);

endmodule