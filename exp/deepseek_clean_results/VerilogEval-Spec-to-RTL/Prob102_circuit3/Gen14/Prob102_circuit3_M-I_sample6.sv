module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = (a & c) | (a & d) | (b & c) | (b & d);

endmodule