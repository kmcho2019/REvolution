// Module A: Implements z = (x ^ y) & x
module A(input wire x, input wire y, output wire z);
    assign z = (x ^ y) & x;
endmodule

// Module B: Implements z = ~(x ^ y) (XNOR function matching waveform)
module B(input wire x, input wire y, output wire z);
    assign z = ~(x ^ y);
endmodule

// Top-level module refactored for area and power by computing A and B logic inline
module TopModule(input wire x, input wire y, output wire z);
    // Compute outputs of A and B functions once
    wire a_val = (x ^ y) & x;
    wire b_val = ~(x ^ y);

    // First pair combined with OR
    wire or_out = a_val | b_val;

    // Second pair combined with AND
    wire and_out = a_val & b_val;

    // Final output as XOR of OR and AND results
    assign z = or_out ^ and_out;
endmodule