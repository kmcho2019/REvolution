module TopModule(
    input a,
    input b,
    input cin,
    output cout,
    output sum
);
    // Sum is XOR of all inputs (odd parity)
    assign sum = a ^ b ^ cin;
    
    // Carry-out implemented as 4:1 MUX
    assign cout = (a & b) ? 1'b1 :
                  (a | b) ? cin :
                             1'b0;
endmodule