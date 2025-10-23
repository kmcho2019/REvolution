// TopModule: A combinational circuit implementing the logic derived from K-map simplification
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // The output q is 1 when an odd number of inputs are 1, except when all inputs are 0
    // We implement this using a combination of AND, OR, and NOT gates
    logic all_zero;  // Signal to detect all inputs being 0
    logic one_input;  // Signal to detect exactly one input being 1
    logic three_inputs;  // Signal to detect exactly three inputs being 1

    assign all_zero = ~a & ~b & ~c & ~d;
    assign one_input = (a & ~b & ~c & ~d) | (~a & b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d);
    assign three_inputs = (a & b & c & ~d) | (a & b & ~c & d) | (a & ~b & c & d) | (~a & b & c & d);

    assign q = all_zero | one_input | three_inputs;

    // This implementation directly follows from the K-map simplification and captures the required logic
    // The use of separate signals for detecting specific input conditions improves readability and maintainability

endmodule