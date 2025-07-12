// Module to compute outputs of A and B for a given (x, y) pair,
// and combine them for either pair 1 or pair 2.
// sel differentiates the pairs but does not affect logic in this case,
// kept for extensibility and clarity.
module ABPair(
    input wire x,
    input wire y,
    output wire or_out,
    output wire and_out
);
    wire a_out, b_out;

    // Module A: a_out = (x ^ y) & x
    assign a_out = (x ^ y) & x;

    // Module B: from waveform, inferred as b_out = ~(x ^ y)
    assign b_out = ~(x ^ y);

    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
endmodule

// Top module connecting two ABPair modules and producing final output z
module TopModule(
    input wire x,
    input wire y,
    output wire z
);
    wire or1, and1, or2, and2;

    // First pair computation
    ABPair pair1(.x(x), .y(y), .or_out(or1), .and_out(and1));

    // Second pair computation
    ABPair pair2(.x(x), .y(y), .or_out(or2), .and_out(and2));

    // Final output z = (or1 XOR and1) XOR (or2 XOR and2)
    // This matches the logic: (A1|B1) XOR (A2&B2) with symmetry in pairs
    assign z = (or1 ^ and1) ^ (or2 ^ and2);

endmodule