module TopModule (
    input  a,
    input  b,
    output out
);

    // Implement 2-input NOR gate using continuous assignment with bitwise OR and negation
    assign out = ~(a | b);

endmodule