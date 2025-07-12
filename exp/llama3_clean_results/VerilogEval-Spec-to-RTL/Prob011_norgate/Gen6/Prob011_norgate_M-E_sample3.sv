module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~(&a & b);
    // Alternatively, for clarity and to follow the thought more directly:
    // assign out = ~(a & b);
endmodule