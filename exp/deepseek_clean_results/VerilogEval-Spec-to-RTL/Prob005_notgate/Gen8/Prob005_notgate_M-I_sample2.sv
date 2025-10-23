module TopModule (
    input in,
    output out
);
    // Optimal NOT gate implementation - no improvements possible
    assign out = ~in;
endmodule