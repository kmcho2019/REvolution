module TopModule(
    input a,
    input b,
    output out
);
    // Direct implementation of NOR gate using logical operators
    assign out = ~(a | b);
endmodule