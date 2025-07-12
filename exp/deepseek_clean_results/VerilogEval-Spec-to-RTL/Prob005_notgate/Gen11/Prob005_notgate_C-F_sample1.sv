// Optimal NOT gate implementation
// - Uses direct assignment for best PPA
// - Single gate implementation minimizes area and power
// - Zero-delay operation for maximum performance
module TopModule (
    input in,
    output out
);
    assign out = ~in;  // Direct NOT gate implementation
endmodule