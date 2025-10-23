module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire ab_sum;
    wire cd_sum;

    // Logical OR can be represented by addition in 1-bit as any nonzero sum is 1
    assign ab_sum = (a + b) ? 1'b1 : 1'b0;
    assign cd_sum = (c + d) ? 1'b1 : 1'b0;

    assign q = ab_sum & cd_sum;

endmodule