module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Decoder for a and b
    wire ab00 = ~a & ~b;
    wire ab01 = ~a & b;
    wire ab10 = a & ~b;
    wire ab11 = a & b;
    wire any_ab = ~ab00;  // Inverted when none are active

    // Decoder for c and d
    wire cd00 = ~c & ~d;
    wire cd01 = ~c & d;
    wire cd10 = c & ~d;
    wire cd11 = c & d;
    wire any_cd = ~cd00;  // Inverted when none are active

    assign q = any_ab & any_cd;

endmodule