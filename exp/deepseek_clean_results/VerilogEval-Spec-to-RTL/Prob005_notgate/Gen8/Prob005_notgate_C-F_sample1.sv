module TopModule (
    input in,
    output wire out
);
    // Optimal NOT gate implementation
    assign out = ~in;
endmodule