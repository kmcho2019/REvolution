module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Output is true when at least one from {a,b} AND at least one from {c,d} is true
    wire any_ab = a | b;  // OR of first input pair
    wire any_cd = c | d;  // OR of second input pair
    
    assign q = any_ab & any_cd;  // Final AND condition

endmodule