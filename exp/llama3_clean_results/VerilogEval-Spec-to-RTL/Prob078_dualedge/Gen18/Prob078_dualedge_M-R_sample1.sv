module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Use assign for sequential logic where possible
always @(posedge clk) q_pos <= d;
always @(negedge clk) q_neg <= d;

// Alternative: Use a single always block for both edges
// However, the sensitivity list (posedge or negedge) is not directly supported
// Hence, sticking with the original separate always blocks for clarity and synthesis compatibility

// Select output based on clock edge, maintaining the original assign statement
assign q = (clk) ? q_pos : q_neg;

endmodule