module TopModule(
    input a,
    input b,
    output out
);
    // Direct implementation of 2-input AND gate
    // using logical AND operator for optimal PPA
    assign out = a & b;
endmodule