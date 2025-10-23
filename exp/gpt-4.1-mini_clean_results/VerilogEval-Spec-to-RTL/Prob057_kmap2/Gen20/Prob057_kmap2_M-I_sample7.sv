// Module for term: ~c & ~d & (~a | ~b)
module Term1(
    input  a_inv,
    input  b_inv,
    input  c_inv,
    input  d_inv,
    output term_out
);
    assign term_out = c_inv & d_inv & (a_inv | b_inv);
endmodule

// Module for term: ~c & d & ~b
module Term2(
    input  b_inv,
    input  c_inv,
    input  d,
    output term_out
);
    assign term_out = c_inv & d & b_inv;
endmodule

// Module for term: c & ~d & ~a
module Term3(
    input  a_inv,
    input  c,
    input  d_inv,
    output term_out
);
    assign term_out = c & d_inv & a_inv;
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
    // Compute inverted signals once
    wire a_inv = ~a;
    wire b_inv = ~b;
    wire c_inv = ~c;
    wire d_inv = ~d;

    wire t1, t2, t3, t4;

    Term1 term1_inst(.a_inv(a_inv), .b_inv(b_inv), .c_inv(c_inv), .d_inv(d_inv), .term_out(t1));
    Term2 term2_inst(.b_inv(b_inv), .c_inv(c_inv), .d(d), .term_out(t2));
    Term3 term3_inst(.a_inv(a_inv), .c(c), .d_inv(d_inv), .term_out(t3));
    Term4 term4_inst(.a(a), .b(b), .c(c), .d(d), .term_out(t4));

    assign out = t1 | t2 | t3 | t4;
endmodule