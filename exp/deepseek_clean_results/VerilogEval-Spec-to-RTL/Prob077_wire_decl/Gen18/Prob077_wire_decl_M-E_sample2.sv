module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Single expression combining all operations
    assign out = (a & b) | (c & d);
    assign out_n = ~out;
endmodule