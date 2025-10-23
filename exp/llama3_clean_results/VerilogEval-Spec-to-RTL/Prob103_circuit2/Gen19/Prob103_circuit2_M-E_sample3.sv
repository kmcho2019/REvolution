// TopModule: A combinational circuit implementing the output based on the parity of input counts
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Calculate the parity of the count of 1's among inputs
    assign q = ~(a ^ b ^ c ^ d);  // Use XOR operator (^) followed by NOT operator (~)

    // Alternative implementation using AND and XOR to directly check parity
    // logic parity;
    // assign parity = a ^ b ^ c ^ d;
    // assign q = ~parity;

endmodule