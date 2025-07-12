module TopModule (
    input  a,
    input  b,
    output out
);
    // Directly instantiate the nor primitive gate for minimal area and power overhead
    nor (out, a, b);
endmodule