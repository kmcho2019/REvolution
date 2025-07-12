/**
 * Full Adder Module
 * Implements a 1-bit full adder with carry-in and carry-out
 * Sum = a XOR b XOR cin
 * Carry-out = (a AND b) OR (b AND cin) OR (a AND cin)
 */
module TopModule(
    input  wire a,    // First input bit
    input  wire b,    // Second input bit
    input  wire cin,  // Carry-in bit
    output wire cout, // Carry-out bit
    output wire sum   // Sum bit
);
    // Sum calculation using XOR
    assign sum = a ^ b ^ cin;
    
    // Carry-out calculation using majority function
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule