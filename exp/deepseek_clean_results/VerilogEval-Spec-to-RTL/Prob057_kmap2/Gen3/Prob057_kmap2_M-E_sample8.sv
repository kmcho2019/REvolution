module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire group1 = ~c & ~d & (~a | ~b);
    wire group2 = c & d & (a | b);
    wire group3 = c & ~d & (a ^ b);
    wire group4 = ~c & d & ~(a ^ b);

    assign out = group1 | group2 | group3 | group4;

endmodule