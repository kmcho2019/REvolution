module TopModule (
    input  a,
    input  b,
    output out
);

    // Instantiate built-in primitive NOR gate
    nor (out, a, b);

endmodule