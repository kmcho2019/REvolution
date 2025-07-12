module TopModule (
    input  a,
    input  b,
    output out
);
    // Gate-level primitive instantiation
    and and_gate(out, a, b);
endmodule