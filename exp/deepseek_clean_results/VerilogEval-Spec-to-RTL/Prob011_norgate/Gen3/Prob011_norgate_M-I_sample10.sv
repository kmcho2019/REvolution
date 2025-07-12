module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Optimal NOR gate implementation
endmodule