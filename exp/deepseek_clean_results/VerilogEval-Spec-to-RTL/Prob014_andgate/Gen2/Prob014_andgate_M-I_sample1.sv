module TopModule (
    input a,       // First input signal
    input b,       // Second input signal
    output out     // AND gate output
);
    // Continuous assignment implementing 2-input AND function
    // Output is high only when both inputs are high
    assign out = a & b;
endmodule