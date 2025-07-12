module TopModule (
    input  a,
    input  b,
    output out
);
    // NOR gate implementation
    assign out = ~(a | b);  // Alternative syntax with identical PPA results
endmodule