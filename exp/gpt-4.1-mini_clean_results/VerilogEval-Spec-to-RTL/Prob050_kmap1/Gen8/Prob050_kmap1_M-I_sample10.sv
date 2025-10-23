module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Implement the function directly using built-in operators:
    // out = ~(~a & ~b & ~c) = a | b | c
    assign out = a | b | c;

endmodule