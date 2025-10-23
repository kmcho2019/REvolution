module TopModule(
    input a,
    input b,
    output out
);
    // Direct continuous assignment using XNOR operator
    assign out = ~(a ^ b);
endmodule