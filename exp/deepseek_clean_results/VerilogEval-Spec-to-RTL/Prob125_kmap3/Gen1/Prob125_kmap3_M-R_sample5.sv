module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Refactored logic that correctly implements the K-map
    assign out = (a ^ b) ? (c | (a & b)) : (b & ~c & ~d);
endmodule