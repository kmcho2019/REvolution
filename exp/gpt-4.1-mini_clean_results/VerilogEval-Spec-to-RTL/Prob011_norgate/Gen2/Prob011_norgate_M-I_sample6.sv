module TopModule(
    input  a,
    input  b,
    output out
);
    // Implementing a 2-input NOR gate using Verilog primitive
    nor (out, a, b);
endmodule