// Module for a 2-to-1 multiplexer
module MUX2(
    input  a,
    input  b,
    input  sel,
    output q
);
    
    // Assign the output based on the select signal
    assign q = sel? b : a;
    
endmodule

// Module for a 4-to-1 multiplexer
module MUX4(
    input  a,
    input  b,
    input  c,
    input  d,
    input  [1:0] sel,
    output q
);
    
    // Intermediate wires to hold the results of 2-to-1 multiplexers
    wire ab;
    wire cd;
    
    // Instantiate 2-to-1 multiplexers for (a, b) and (c, d)
    MUX2 u_ab(.a(a),.b(b),.sel(sel[0]),.q(ab));
    MUX2 u_cd(.a(c),.b(d),.sel(sel[0]),.q(cd));
    
    // Instantiate a 2-to-1 multiplexer to select between ab and cd
    MUX2 u_ab_cd(.a(ab),.b(cd),.sel(sel[1]),.q(q));
    
endmodule

// Top-level module implementing the combinational circuit
module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    
    // Instantiate a 4-to-1 multiplexer to select the output based on a and b
    MUX4 u_mux(.a(0),.b(0),.c(1),.d(1),.sel({a, b}),.q(q));
    
endmodule