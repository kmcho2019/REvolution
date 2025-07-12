module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Output is 1 for all cases except a=0, b=0, c=0 (K-map derived)
    assign out = (a | b | c);
endmodule