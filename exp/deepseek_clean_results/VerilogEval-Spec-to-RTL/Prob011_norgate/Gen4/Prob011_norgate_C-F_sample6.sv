module TopModule (
    input a,
    input b,
    output out
);
    // Optimal NOR gate implementation
    assign out = ~(a | b);
endmodule