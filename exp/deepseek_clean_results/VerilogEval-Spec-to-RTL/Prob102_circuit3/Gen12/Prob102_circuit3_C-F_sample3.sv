module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire or_ab = a | b;
    wire or_cd = c | d;
    
    assign q = or_ab & or_cd;

endmodule