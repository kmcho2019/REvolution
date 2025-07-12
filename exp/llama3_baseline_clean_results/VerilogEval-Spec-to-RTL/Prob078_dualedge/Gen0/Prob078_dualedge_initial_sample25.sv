module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg_pos, q_reg_neg; // Outputs of the two flip-flops

// Positive edge triggered flip-flop
always @(posedge clk)
    q_reg_pos <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    q_reg_neg <= d;

// Output 'q' is a multiplexer that selects based on the clock edge
// Since we can't directly use 'posedge' or 'negedge' in an always block for synthesis,
// we'll use the 'clk' signal itself to decide which flip-flop's output to use
always @(posedge clk or negedge clk)
    if (clk) // If clk is high, the last transition was a positive edge
        q <= q_reg_pos;
    else // If clk is low, the last transition was a negative edge
        q <= q_reg_neg;

endmodule