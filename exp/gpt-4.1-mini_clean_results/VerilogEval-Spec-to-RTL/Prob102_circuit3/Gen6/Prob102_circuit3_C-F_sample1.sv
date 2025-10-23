module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire a_or_b = a | b;
    wire c_or_d = c | d;

    assign q = a_or_b & c_or_d;

endmodule