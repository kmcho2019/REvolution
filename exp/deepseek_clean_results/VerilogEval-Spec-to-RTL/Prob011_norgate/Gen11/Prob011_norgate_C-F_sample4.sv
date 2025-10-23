module TopModule (
    input  a,    // First input signal
    input  b,    // Second input signal
    output out   // NOR gate output
);
    // Efficient NOR implementation using continuous assignment
    assign out = ~(a | b);
endmodule