module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Intermediate signals for next states B and D (y[1] and y[3])
wire next_B;
wire next_D;

// next_B (Y1) corresponds to next state B (y[1]) which is never directly next from given transitions,
// so assign 0 to explicitly show no transitions result in next_B.
// If needed, can be kept as 0.
assign next_B = 1'b0;

// next_D (Y3) corresponds to next state D (y[3]) per transitions:
assign next_D = w & (y[1] | y[2] | y[4] | y[5]);

// Output assignments
assign Y1 = next_B; // next state y[1]
assign Y3 = next_D; // next state y[3]

endmodule