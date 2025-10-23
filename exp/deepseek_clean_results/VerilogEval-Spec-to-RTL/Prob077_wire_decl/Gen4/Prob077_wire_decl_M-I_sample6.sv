module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    assign {out, out_n} = {(a & b) | (c & d), ~((a & b) | (c & d))};

endmodule