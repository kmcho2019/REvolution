// TopModule: A combinational circuit implementing the logic described by the simulation waveforms
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Implement the logic using a sum of products
    assign q = (~a & ~b & ~c & ~d) |  // All inputs low
               (a & ~b & ~c & d) |   // a high, others low except d
               (~a & b & ~c & d) |   // b high, others low except d
               (~a & ~b & c & d) |   // c high, others low except d
               (~a & b & c & ~d) |   // b and c high, a and d low
               (a & ~b & c & ~d) |   // a and c high, b and d low
               (a & b & ~c & ~d);    // a and b high, c and d low

endmodule