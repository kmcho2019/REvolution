module TopModule(
    input a,
    input b,
    output sum,
    output cout
);
    // Sum (XOR) implementation using mux
    assign sum = a ? ~b : b;
    
    // Carry (AND) implementation using mux
    assign cout = a ? b : 1'b0;
endmodule