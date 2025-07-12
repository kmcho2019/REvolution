module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire not_a, not_b, not_c, not_d;
    wire nor_ab, nor_cd;
    
    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    assign not_d = ~d;
    
    // NOR of a and b = ~(a|b) = ~a & ~b
    assign nor_ab = not_a & not_b;
    // NOR of c and d = ~(c|d) = ~c & ~d
    assign nor_cd = not_c & not_d;
    
    // q = ~ (nor_ab | nor_cd) = (a | b) & (c | d)
    assign q = ~(nor_ab | nor_cd);

endmodule