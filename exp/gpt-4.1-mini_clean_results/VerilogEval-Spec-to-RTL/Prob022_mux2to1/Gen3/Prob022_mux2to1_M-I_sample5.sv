module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);
    // One-bit 2-to-1 MUX: out = sel ? b : a;
    // This continuous assignment is synthesized as a single 2:1 mux gate.
    assign out = sel ? b : a;
endmodule