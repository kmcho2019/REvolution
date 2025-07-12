module TopModule (
    input  a,
    input  b,
    output out
);
    // Continuous assignment implementing the NOR gate
    assign out = ~(a | b);
endmodule