module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial binary sum (5-bit to capture overflow)
    wire [4:0] raw_sum = A + B + Cin;
    
    // Detect if correction is needed (sum > 9 or carry occurred)
    // Optimized version of: raw_sum > 9
    wire needs_correction = raw_sum[4] ||         // Sum >= 16
                          (raw_sum[3] &&         // Sum >= 8
                          (raw_sum[2] || raw_sum[1]));  // Sum >= 10 or 12
    
    // Apply correction (either +0 or +6) using efficient conditional addition
    // This is equivalent to: corrected_sum = raw_sum[3:0] + (needs_correction ? 6 : 0)
    // But implemented more efficiently:
    wire [3:0] corrected_sum = raw_sum[3:0] + {1'b0, needs_correction, needs_correction, 1'b0};
    
    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = needs_correction;

endmodule