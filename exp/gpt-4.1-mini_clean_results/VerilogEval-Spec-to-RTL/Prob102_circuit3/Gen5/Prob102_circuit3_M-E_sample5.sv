module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire c_or_d;
    wire a_and_cd;
    wire b_and_cd;

    assign c_or_d = c | d;
    assign a_and_cd = a & c_or_d;
    assign b_and_cd = b & c_or_d;

    assign q = a_and_cd | b_and_cd;
endmodule