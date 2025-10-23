module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Equivalent to x XNOR y which matches the truth table
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Directly wire the intermediate signals without separate declarations
    wire or_out = ( (x ^ y) & x ) | ( ~(x ^ y) );  // A1 output OR B1 output
    wire and_out = ( (x ^ y) & x ) & ( ~(x ^ y) ); // A2 output AND B2 output
    
    assign z = or_out ^ and_out;
endmodule