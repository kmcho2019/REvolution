module TopModule (
    input  a,
    input  b,
    output out
);

    // Implement 2-input NOR gate using primitive nor gate
    nor (out, a, b);

endmodule