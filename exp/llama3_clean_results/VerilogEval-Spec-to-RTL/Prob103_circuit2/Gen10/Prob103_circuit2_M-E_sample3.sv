// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Calculate the output as the inverse of the parity of the input bits
    // This is done by checking all combinations that result in an odd number of 1's
    assign q = ~( (a & ~b & ~c & ~d) | 
                 (~a & b & ~c & ~d) | 
                 (~a & ~b & c & ~d) | 
                 (~a & ~b & ~c & d) | 
                 (a & b & c & ~d) | 
                 (a & b & ~c & d) | 
                 (a & ~b & c & d) | 
                 (~a & b & c & d));

endmodule