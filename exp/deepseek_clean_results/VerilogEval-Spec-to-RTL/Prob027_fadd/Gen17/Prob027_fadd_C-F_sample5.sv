module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum as parity of all inputs (optimal XOR implementation)
    assign sum = a ^ b ^ cin;
    
    // Carry-out as majority function (clear symmetric implementation)
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule