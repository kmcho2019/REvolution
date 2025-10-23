module TopModule (
    input  a,
    input  b,
    output out
);
    // Instantiate the NOR gate primitive directly
    nor (out, a, b);
endmodule