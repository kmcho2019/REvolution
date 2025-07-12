module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = (a == b && c != d) || (a == 0 && b == 0 && c == 0 && d == 0);

endmodule