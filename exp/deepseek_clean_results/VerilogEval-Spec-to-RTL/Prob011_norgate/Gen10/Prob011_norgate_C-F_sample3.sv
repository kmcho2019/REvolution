module TopModule (
    input a,
    input b,
    output out
);
    // Optimal NOR gate implementation using continuous assignment
    // Directly maps to physical NOR gate implementation
    assign out = ~(a | b);
endmodule