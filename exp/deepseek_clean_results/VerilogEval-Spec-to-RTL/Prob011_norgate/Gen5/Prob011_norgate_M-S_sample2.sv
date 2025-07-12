module TopModule(
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Already simplest possible NOR implementation
endmodule