module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_or;  // Intermediate signal: a OR b
    wire cd_or;  // Intermediate signal: c OR d

    assign ab_or = a | b;
    assign cd_or = c | d;
    assign q = ab_or & cd_or;

endmodule