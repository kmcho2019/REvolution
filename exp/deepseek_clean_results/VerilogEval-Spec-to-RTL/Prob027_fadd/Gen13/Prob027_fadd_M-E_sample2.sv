module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    wire a_and_b = a & b;
    wire a_nor_b = ~(a | b);
    
    // Sum calculation using mux
    assign sum = a_xor_b ? ~cin : cin;
    
    // Carry calculation using prioritized mux
    assign cout = a_and_b ? 1'b1 : 
                 a_nor_b ? 1'b0 : 
                 cin;
endmodule