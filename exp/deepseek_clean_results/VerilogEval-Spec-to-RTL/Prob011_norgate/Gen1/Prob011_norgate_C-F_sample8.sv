module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Explicit NOR implementation for maximum clarity
endmodule