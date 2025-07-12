module TopModule (
    input a,
    input b,
    output out
);
    // NOR gate implementation using primitive
    nor g1(out, a, b);
endmodule