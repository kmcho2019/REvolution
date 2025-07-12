module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    
    // Carry-out: if (a == b) select a, else select cin
    assign cout = (a_xor_b) ? cin : a;
    
    // Sum: if (cin == 0) select a_xor_b, else select ~a_xor_b
    assign sum = (cin) ? ~a_xor_b : a_xor_b;
endmodule