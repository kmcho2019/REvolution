module TopModule (
    input a,
    input b,
    output out
);
    // Optimal implementation confirmed - maintain original solution
    assign out = ~(a ^ b);
endmodule