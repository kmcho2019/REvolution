module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Implement the K-map directly:
    // Output is 1 when:
    // 1. a=1 and (c=1 or b=0) [covers most 1s in K-map]
    // 2. Or when a=0, c=1, b=0 [specific case from K-map]
    assign out = (a & (c | ~b)) | (~a & c & ~b);
endmodule