module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire any_ab = a | b;  // At least one of a or b is true
    wire any_cd = c | d;  // At least one of c or d is true
    
    assign q = any_ab & any_cd;  // Both conditions must be true

endmodule