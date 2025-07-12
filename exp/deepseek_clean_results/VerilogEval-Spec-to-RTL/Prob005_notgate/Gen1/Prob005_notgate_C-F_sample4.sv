module TopModule (
    input in,      // Input signal
    output out     // Output signal (logical NOT of input)
);
    assign out = ~in;  // NOT gate implementation
endmodule