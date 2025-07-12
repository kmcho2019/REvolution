module TopModule (
    input a,    // First input bit
    input b,    // Second input bit
    input c,    // Third input bit
    input d,    // Fourth input bit
    output q    // Output: 1 when even number of inputs are 1 (0, 2, or 4)
);

    // Efficient even parity check using XOR properties:
    // XOR chain produces 1 when odd number of inputs are 1
    // Inversion gives us the desired even parity output
    assign q = ~(a ^ b ^ c ^ d);

    /* Alternative implementation options:
    // 1. Using reduction XOR (if supported by synthesis tools)
    // assign q = ~^ {a, b, c, d};
    
    // 2. Using built-in parity function (if available)
    // assign q = ~(^ {a, b, c, d});
    */

endmodule