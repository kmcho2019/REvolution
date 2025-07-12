module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
    );

    assign q = (a & ~c) | (~a & ~c & (b ^ d)) | (a & c & ~(b ^ d));

endmodule