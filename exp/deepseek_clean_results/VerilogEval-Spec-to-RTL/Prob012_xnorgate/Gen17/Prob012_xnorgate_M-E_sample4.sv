module TopModule (
    input a,
    input b,
    output out
);
    wire a_eq_b;
    wire a_neq_b;
    
    assign a_eq_b = ~(a ^ b);  // XNOR equivalent
    assign a_neq_b = a ^ b;    // XOR
    
    // MUX implementation
    assign out = (a) ? a_eq_b : a_neq_b;
endmodule