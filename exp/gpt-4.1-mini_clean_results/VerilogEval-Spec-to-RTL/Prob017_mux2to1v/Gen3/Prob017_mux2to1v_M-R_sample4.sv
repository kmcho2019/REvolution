module TopModule(
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    output [99:0] out
);
    // Direct vector-wide 2-to-1 mux using continuous assignment
    assign out = sel ? b : a;
endmodule