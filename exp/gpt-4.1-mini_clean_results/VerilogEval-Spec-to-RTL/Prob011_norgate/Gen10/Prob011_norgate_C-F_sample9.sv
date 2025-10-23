module TopModule (
    input  a,
    input  b,
    output out
);
    // Direct instantiation of NOR primitive for minimal, clear, and efficient implementation
    nor (out, a, b);
endmodule