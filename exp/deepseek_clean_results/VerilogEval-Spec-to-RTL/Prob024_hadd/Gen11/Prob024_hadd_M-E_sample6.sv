module TopModule (
    input a,
    input b,
    output sum,
    output cout
);

    wire sel;
    xor x1(sel, a, b);
    
    // MUX implementation for sum
    assign sum = sel ? 1'b1 : 1'b0;
    
    // Traditional AND for carry
    and c1(cout, a, b);

endmodule