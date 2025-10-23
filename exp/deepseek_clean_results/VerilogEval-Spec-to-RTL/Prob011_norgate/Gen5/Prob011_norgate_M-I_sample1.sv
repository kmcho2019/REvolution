module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Already optimal NOR gate implementation
endmodule