module TopModule(
    input a,
    input b,
    output out
);
    // Continuous assignment for optimal 2-input AND implementation
    assign out = a & b;
endmodule