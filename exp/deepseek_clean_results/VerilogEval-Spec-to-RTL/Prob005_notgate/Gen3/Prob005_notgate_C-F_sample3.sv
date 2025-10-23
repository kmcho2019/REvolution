module TopModule (
    input in,
    output out
);
    // Simple and optimal NOT gate implementation
    // out is the logical inverse of in (1 when in=0, 0 when in=1)
    assign out = ~in;
endmodule