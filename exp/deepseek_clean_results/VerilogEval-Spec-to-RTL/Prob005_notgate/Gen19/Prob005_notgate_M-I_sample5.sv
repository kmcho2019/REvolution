module TopModule (
    input in,
    output out
);
    assign out = ~in;  // This remains the optimal implementation
endmodule