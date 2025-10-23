module TopModule (
    input a,
    input b,
    output q
);
    // Explicit combinational AND gate implementation
    // q = 1 only when both a AND b are 1
    assign q = a & b;
endmodule