module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Optimal implementation already found
    assign out = a | (~a & ~b & c);
endmodule