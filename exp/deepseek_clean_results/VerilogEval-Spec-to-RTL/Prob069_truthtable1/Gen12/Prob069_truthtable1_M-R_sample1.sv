module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    wire not_x3;
    wire term1;  // ~x3 & x2
    wire term2;  // x3 & x1
    
    not inv1(not_x3, x3);
    and and1(term1, not_x3, x2);
    and and2(term2, x3, x1);
    or or1(f, term1, term2);
endmodule