module OR_Gate(
    input  a,
    input  b,
    output q
);
    
    assign q = a | b;
    
endmodule

module AND_Gate(
    input  a,
    input  b,
    output q
);
    
    assign q = a & b;
    
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    wire ab_or, cd_or;
    
    OR_Gate u_ab_or(.a(a), .b(b), .q(ab_or));
    OR_Gate u_cd_or(.a(c), .b(d), .q(cd_or));
    
    AND_Gate u_and_gate(.a(ab_or), .b(cd_or), .q(q));
    
endmodule