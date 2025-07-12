module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire group1_active = a | b;
    wire group2_active = c | d;
    
    assign q = group1_active & group2_active;

endmodule