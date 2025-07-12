module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Direct sum calculation
    assign sum = a ^ b ^ cin;
    
    // Direct carry-out calculation
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule