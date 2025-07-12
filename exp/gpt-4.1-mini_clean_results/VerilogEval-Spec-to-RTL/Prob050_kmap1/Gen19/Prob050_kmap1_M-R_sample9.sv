module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Compute the output as ~(~a & ~b & ~c) directly using assign statement
    assign out = ~((~a) & (~b) & (~c));

endmodule