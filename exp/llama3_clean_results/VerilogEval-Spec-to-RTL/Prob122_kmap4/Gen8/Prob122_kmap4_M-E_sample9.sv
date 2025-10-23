module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire ab_diff;  // 'a' and 'b' are different
    wire cd_same;  // 'c' and 'd' are the same
    wire ab_same;  // 'a' and 'b' are the same
    wire cd_diff;  // 'c' and 'd' are different

    // Generate signals for differences and similarities
    assign ab_diff = a ^ b;
    assign cd_same = ~(c ^ d);
    assign ab_same = ~(a ^ b);
    assign cd_diff = c ^ d;

    // Combine signals to produce the final output
    assign out = (ab_diff & cd_same) | (ab_same & cd_diff);

endmodule