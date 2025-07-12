module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_or = a | b;  // Either a or b is true
    wire cd_or = c | d;  // Either c or d is true
    
    assign q = ab_or & cd_or;  // Both conditions must be true

endmodule