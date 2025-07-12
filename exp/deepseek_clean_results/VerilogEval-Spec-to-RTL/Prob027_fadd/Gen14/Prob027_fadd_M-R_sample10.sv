module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_xor, ab_and, abc_and;
    
    xor x1(ab_xor, a, b);
    xor x2(sum, ab_xor, cin);
    
    and a1(ab_and, a, b);
    and a2(abc_and, ab_xor, cin);
    
    or o1(cout, ab_and, abc_and);
endmodule