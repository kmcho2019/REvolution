// TopModule: A half adder that calculates the sum and carry-out of two input bits.
module TopModule(
    input  a,  // First input bit
    input  b,  // Second input bit
    output sum,  // Sum of the input bits
    output cout  // Carry-out
);

    // Calculate the sum of the input bits using an XOR operation.
    // In binary addition, when two bits are different, the result is 1.
    assign sum = a ^ b;  

    // Calculate the carry-out by performing an AND operation between the input bits.
    // A carry-out occurs when both input bits are 1.
    assign cout = a & b;  

endmodule