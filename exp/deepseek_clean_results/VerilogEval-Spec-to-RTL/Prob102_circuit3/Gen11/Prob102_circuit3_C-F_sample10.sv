module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_or;  // OR of a and b
    wire cd_or;  // OR of c and d
    
    assign ab_or = a | b;
    assign cd_or = c | d;
    assign q = ab_or & cd_or;

endmodule