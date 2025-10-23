module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Intermediate signals
    wire a_or_b, a_and_b;
    
    assign a_or_b = a | b;
    assign a_and_b = a & b;
    
    // Sum output: equivalent to a ^ b ^ cin
    assign sum = cin ? ~(a ^ b) : (a ^ b);
    
    // Carry-out output: (a_and_b) OR (cin AND a_or_b)
    assign cout = (sum) ? a_or_b : a_and_b;
endmodule