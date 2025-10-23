module TopModule (
    input  a,
    input  b,
    output out
);

    // Direct NOR operation
    assign out = ~(a | b);

endmodule