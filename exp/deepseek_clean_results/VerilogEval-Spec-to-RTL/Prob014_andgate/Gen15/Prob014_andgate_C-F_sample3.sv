module TopModule(
    input  wire a,    // First input signal
    input  wire b,    // Second input signal
    output wire out   // Logical AND of a and b
);
    // Simple 2-input AND gate implementation
    assign out = a & b;
endmodule