module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire ab_condition = |{a, b};  // OR of a and b
    wire cd_condition = |{c, d};  // OR of c and d
    
    assign q = ab_condition & cd_condition;

endmodule