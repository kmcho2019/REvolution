module comparator_2bit(
    input  [1:0] A,
    input  [1:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    assign A_equal = (A == B);
    assign A_greater = (A > B) & ~A_equal;
    assign A_less = (A < B) & ~A_equal;

endmodule

module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    wire msb_greater, msb_equal, msb_less;
    wire lsb_greater, lsb_equal, lsb_less;

    comparator_2bit msb_comp(
      .A(A[3:2]),
      .B(B[3:2]),
      .A_greater(msb_greater),
      .A_equal(msb_equal),
      .A_less(msb_less)
    );

    comparator_2bit lsb_comp(
      .A(A[1:0]),
      .B(B[1:0]),
      .A_greater(lsb_greater),
      .A_equal(lsb_equal),
      .A_less(lsb_less)
    );

    assign A_equal = msb_equal & lsb_equal;
    assign A_greater = msb_greater | (msb_equal & lsb_greater);
    assign A_less = msb_less | (msb_equal & lsb_less);

endmodule