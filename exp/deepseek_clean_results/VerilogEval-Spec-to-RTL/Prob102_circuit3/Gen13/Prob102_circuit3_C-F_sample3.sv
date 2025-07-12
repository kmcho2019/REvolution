module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire group1 = a | b;
    wire group2 = d ? 1'b1 : c;
    
    assign q = group1 & group2;

endmodule