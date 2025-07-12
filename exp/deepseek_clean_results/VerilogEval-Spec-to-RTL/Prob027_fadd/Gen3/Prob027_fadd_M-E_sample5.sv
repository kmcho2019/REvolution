module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire ab_xor = a ^ b;
    wire ab_and = a & b;
    
    // Sum calculation using multiplexer logic
    assign sum = ab_xor ^ cin;
    
    // Carry-out calculation using multiplexer logic
    assign cout = ab_xor ? cin : ab_and;
endmodule