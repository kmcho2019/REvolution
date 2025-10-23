module TopModule(
    input a,
    input b,
    output out
);
    // Maintain optimal 2-input AND implementation
    assign out = a & b;
endmodule