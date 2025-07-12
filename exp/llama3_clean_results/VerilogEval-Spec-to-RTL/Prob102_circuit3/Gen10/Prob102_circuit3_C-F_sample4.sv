module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    assign q = a | b;
    
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    wire ab_or;
    wire cd_or;
    
    OR_Gate u_ab_or(.a(a),.b(b),.q(ab_or));
    OR_Gate u_cd_or(.a(c),.b(d),.q(cd_or));
    
    assign q = ab_or & cd_or;
    
endmodule