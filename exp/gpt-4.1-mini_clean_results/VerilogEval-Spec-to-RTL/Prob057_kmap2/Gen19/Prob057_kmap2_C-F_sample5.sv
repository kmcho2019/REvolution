// Module for term: ~c & ~d & (~a | ~b)
module Term1(
    input  a,
    input  b,
    input  c,
    input  d,
    output term_out
);
    wire not_a = ~a;
    wire not_b = ~b;
    wire not_c = ~c;
    wire not_d = ~d;

    assign term_out = not_c & not_d & (not_a | not_b);
endmodule

// Module for term: ~c & d & ~b
module Term2(
    input  a,  // unused but kept for uniform interface
    input  b,
    input  c,
    input  d,
    output term_out
);
    wire not_b = ~b;
    wire not_c = ~c;

    assign term_out = not_c & d & not_b;
endmodule

// Module for term: c & ~d & ~a
module Term3(
    input  a,
    input  b,  // unused but kept for uniform interface
    input  c,
    input  d,
    output term_out
);
    wire not_a = ~a;
    wire not_d = ~d;

    assign term_out = c & not_d & not_a;
endmodule

// Module for term: c & d & (a | b)
module Term4(
    input  a,
    input  b,
    input  c,
    input  d,
    output term_out
);
    assign term_out = c & d & (a | b);
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire t1, t2, t3, t4;

    Term1 term1_inst(.a(a), .b(b), .c(c), .d(d), .term_out(t1));
    Term2 term2_inst(.a(a), .b(b), .c(c), .d(d), .term_out(t2));
    Term3 term3_inst(.a(a), .b(b), .c(c), .d(d), .term_out(t3));
    Term4 term4_inst(.a(a), .b(b), .c(c), .d(d), .term_out(t4));

    assign out = t1 | t2 | t3 | t4;
endmodule