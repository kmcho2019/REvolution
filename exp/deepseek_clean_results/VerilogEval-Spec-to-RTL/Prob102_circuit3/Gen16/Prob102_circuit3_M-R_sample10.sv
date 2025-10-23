module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_or = |{a, b};  // Bitwise OR of a and b
    wire cd_or = |{c, d};  // Bitwise OR of c and d
    
    assign q = ab_or & cd_or;

endmodule