module TopModule(
    input a,
    input b,
    output out
);
    // Directly implement the NOR gate using a single assign statement
    // This approach is both efficient and easy to understand
    assign out = ~(a | b);
endmodule