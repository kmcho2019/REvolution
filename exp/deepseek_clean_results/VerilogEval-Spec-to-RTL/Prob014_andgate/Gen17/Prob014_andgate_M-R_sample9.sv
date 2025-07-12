module TopModule(
    input a,
    input b,
    output out
);
    and g1(out, a, b);  // Direct instantiation of AND gate primitive
endmodule