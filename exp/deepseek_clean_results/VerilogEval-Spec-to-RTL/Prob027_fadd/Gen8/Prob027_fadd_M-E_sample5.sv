module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    
    // Sum is cin when a and b differ, otherwise ~cin
    assign sum = a_xor_b ? cin : ~cin;
    
    // Carry-out is cin when a and b differ, otherwise equal to a (or b)
    assign cout = a_xor_b ? cin : a;
endmodule