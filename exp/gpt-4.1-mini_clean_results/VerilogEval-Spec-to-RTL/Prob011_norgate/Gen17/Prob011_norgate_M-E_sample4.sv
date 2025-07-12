module TopModule (
    input  a,
    input  b,
    output out
);

    // Directly assign NOR output using reduction OR and negation
    assign out = ~(a | b);

endmodule