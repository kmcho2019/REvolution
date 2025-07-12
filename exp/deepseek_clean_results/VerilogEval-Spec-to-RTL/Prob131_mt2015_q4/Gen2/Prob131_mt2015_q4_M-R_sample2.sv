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
    assign z = ~x & ~y | x & y;  // Equivalent to x XNOR y
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Directly wire the outputs to the logic gates
    wire or_out = (x ^ y) & x | (~x & ~y | x & y);  // A1 | B1
    wire and_out = (x ^ y) & x & (~x & ~y | x & y); // A2 & B2
    
    // Final output
    assign z = or_out ^ and_out;
endmodule