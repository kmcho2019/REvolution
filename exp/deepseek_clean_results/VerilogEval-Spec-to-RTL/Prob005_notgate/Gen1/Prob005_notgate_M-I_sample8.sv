module TopModule (
    input in,       // Single input signal
    output out      // Output signal (logical NOT of input)
);
    // Continuous assignment implementing NOT gate functionality
    assign out = ~in;
endmodule