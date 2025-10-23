module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // The simplified logic from K-map analysis
    assign out = (a & ~b) | (~a & b & c) | (b & ~c);
endmodule