module TopModule (
    input in,          // Input signal
    output out         // Inverted output signal
);
    // Simple NOT gate implementation
    assign out = ~in;
endmodule