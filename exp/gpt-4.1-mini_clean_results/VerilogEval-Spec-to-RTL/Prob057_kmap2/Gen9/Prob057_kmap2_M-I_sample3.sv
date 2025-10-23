module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire group1, group2, group3;

    assign group1 = ~c & ~a;
    assign group2 = ~b & ~d;
    assign group3 = c & d & (a | b);

    assign out = group1 | group2 | group3;
endmodule