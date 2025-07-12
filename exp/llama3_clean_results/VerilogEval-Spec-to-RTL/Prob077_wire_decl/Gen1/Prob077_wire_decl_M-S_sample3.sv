module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

or or1((a & b) | (c & d), 1'b0, out);
not not1(out, out_n);

endmodule