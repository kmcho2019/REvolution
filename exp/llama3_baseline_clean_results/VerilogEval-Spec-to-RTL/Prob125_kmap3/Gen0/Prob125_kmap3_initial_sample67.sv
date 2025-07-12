module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (c == 0) ? ((a == 0 && b == 0) || b) : 1;

endmodule