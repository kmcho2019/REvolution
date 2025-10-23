module TopModule(
    input  a,    // First input signal
    input  b,    // Second input signal
    output out   // NOR gate output
);
    // Behavioral implementation of NOR function
    assign out = ~(a | b);
endmodule