// Optimized 2:1 Multiplexer using continuous assignment
module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    assign out = sel ? b : a;
endmodule