module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum calculation using MUX-like logic
    assign sum = cin ? ~(a ^ b) : (a ^ b);
    
    // Carry-out calculation using MUX
    assign cout = (a ^ b) ? cin : (a & b);
endmodule