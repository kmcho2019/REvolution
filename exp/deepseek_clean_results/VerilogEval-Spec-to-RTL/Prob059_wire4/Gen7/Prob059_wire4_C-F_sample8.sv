module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Direct connections with clear grouping
    assign w = a;    // a -> w (1:1)
    assign x = b;    // b -> x (1:1)
    assign y = b;    // b -> y (1:2 fanout)
    assign z = c;    // c -> z (1:1)
endmodule