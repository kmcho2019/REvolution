module TopModule(
    input  a, b,    // Input signals
    output out      // AND gate output
);
    // Continuous assignment implementing 2-input AND function
    assign out = a & b;
endmodule