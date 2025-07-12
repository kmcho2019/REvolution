module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_ff_q; // Output of positive edge triggered flip-flop
reg neg_ff_q; // Output of negative edge triggered flip-flop

// Positive edge triggered flip-flop
always @(posedge clk)
    pos_ff_q <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    neg_ff_q <= d;

// Generate output q based on the last edge
always @(posedge clk or negedge clk)
    if (clk) // If clk is high, the last edge was a positive edge
        q <= pos_ff_q;
    else // If clk is low, the last edge was a negative edge
        q <= neg_ff_q;

endmodule