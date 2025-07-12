module TopModule (
    input a,
    input b,
    input c,
    output out
);
    // Output is 0 only when all inputs are 0
    assign out = ~(~a & ~b & ~c);
endmodule