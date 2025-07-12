module TopModule (
    input in,
    output out
);
    assign out = ~in;  // Optimal NOT gate implementation
endmodule