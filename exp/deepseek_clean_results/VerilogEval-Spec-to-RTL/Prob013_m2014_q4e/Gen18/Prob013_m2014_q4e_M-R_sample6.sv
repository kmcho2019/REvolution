module TopModule (
    input in1,
    input in2,
    output out
);
    // Explicit NOR gate primitive instantiation
    nor g1(out, in1, in2);
endmodule