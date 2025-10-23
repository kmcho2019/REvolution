module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Implement the function directly with a single 3-input OR expression
    assign out = a | b | c;

endmodule