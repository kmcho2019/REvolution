module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);
    wire not_a, not_b, not_c, not_d;
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    assign not_d = ~d;

    // minterms where output is 1:
    // !c!d!a!b
    wire m0 = not_c & not_d & not_a & not_b;
    // !c!d!a b
    wire m1 = not_c & not_d & not_a & b;
    // !c!d a !b
    wire m2 = not_c & not_d & a & not_b;
    // !c d !a !b
    wire m3 = not_c & d & not_a & not_b;
    // !c d a !b
    wire m4 = not_c & d & a & not_b;
    // c d !a b
    wire m5 = c & d & not_a & b;
    // c d a b
    wire m6 = c & d & a & b;
    // c d a !b
    wire m7 = c & d & a & not_b;
    // c !d !a !b
    wire m8 = c & not_d & not_a & not_b;
    // c !d !a b
    wire m9 = c & not_d & not_a & b;
    // !c d a !b  (Already m4)
    // !c d !a !b (m3)
    // !c!d!a!b (m0)
    // !c!d!a b (m1)
    // !c!d a !b (m2)
    // c d a !b (m7)
    // c d !a b (m5)
    // c d a b (m6)
    // c !d !a !b (m8)
    // c !d !a b (m9)

    assign out = m0 | m1 | m2 | m3 | m4 | m5 | m6 | m7 | m8 | m9;

endmodule