module MUX2to1(
    input  sel,
    input  a,
    input  b,
    output q
);
    
    assign q = sel? b : a;
    
endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    wire not_a, not_c, ab_sel, cd_sel;
    
    // Inverters to generate not_a and not_c
    assign not_a = ~a;
    assign not_c = ~c;
    
    // MUXes to select between b (or d) and 1 (or 0) based on a (or c)
    MUX2to1 u_ab_mux(.sel(a),.a(1'b0),.b(b),.q(ab_sel));
    MUX2to1 u_cd_mux(.sel(c),.a(1'b0),.b(d),.q(cd_sel));
    
    // AND gate to combine the outputs of the MUXes
    assign q = ab_sel & cd_sel;
    
endmodule