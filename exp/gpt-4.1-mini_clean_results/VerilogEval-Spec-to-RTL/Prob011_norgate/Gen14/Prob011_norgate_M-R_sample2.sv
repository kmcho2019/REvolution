module TopModule(
    input a,
    input b,
    output out
);
    // Implement 2-input NOR gate using continuous assignment with bitwise operators
    assign out = ~(a | b);
endmodule