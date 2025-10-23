module TopModule(
    input a,
    input b,
    output out
);
    // Optimal 2-input AND gate implementation
    assign out = a & b;
endmodule