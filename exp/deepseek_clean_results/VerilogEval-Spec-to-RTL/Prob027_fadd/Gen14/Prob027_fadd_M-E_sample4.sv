module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    wire a_xor_b = a ^ b;
    wire a_and_b = a & b;
    
    // Carry-out implementation using MUX
    assign cout = a_and_b ? 1'b1 : (a_xor_b ? cin : 1'b0);
    
    // Sum implementation using MUX
    assign sum = a_xor_b ? ~cin : cin;
endmodule