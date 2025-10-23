module TopModule(a, b, c, d, q);
    input a, b, c, d;
    output q;
    wire majority;

    // Majority voter for b, c, and a
    assign majority = (b & c) | (b & a) | (c & a);

    // Determine output q based on majority and a
    assign q = (a & majority) | (~a & (b | c));
endmodule