module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // q is true when (a OR b) AND (c OR d)
    wire ab_or = a | b;
    wire cd_or = c | d;
    assign q = ab_or & cd_or;
endmodule