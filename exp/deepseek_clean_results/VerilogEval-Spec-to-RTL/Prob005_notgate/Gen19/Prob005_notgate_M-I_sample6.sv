module TopModule (
    input in,
    output out
);
    assign out = ~in;  // This remains the most efficient NOT gate implementation
endmodule