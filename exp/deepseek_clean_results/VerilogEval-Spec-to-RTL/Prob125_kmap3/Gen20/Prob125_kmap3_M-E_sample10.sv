module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Mux-based implementation
    // When a=1: out=1
    // When a=0: out=c & ~b (using don't-cares to simplify)
    assign out = a ? 1'b1 : (c & ~b);
endmodule