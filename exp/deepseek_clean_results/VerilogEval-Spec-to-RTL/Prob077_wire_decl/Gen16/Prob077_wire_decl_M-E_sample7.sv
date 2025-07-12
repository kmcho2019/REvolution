module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);
    // Combined logic in single continuous assignment
    assign out = (a & b) | (c & d);
    assign out_n = ~out;
endmodule