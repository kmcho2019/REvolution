/*
 * Half Adder Module
 * Implements: sum = a XOR b
 *             cout = a AND b
 * Optimal gate-level implementation with documentation
 */
module TopModule(
    input  a,    // First input bit
    input  b,    // Second input bit
    output sum,  // Sum output (a XOR b)
    output cout  // Carry output (a AND b)
);
    // Sum calculation using XOR
    assign sum = a ^ b;
    
    // Carry calculation using AND
    assign cout = a & b;
endmodule