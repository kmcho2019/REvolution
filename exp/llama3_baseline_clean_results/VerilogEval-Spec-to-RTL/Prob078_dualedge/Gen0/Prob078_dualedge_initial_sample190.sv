module TopModule(
    input clk,
    input d,
    output reg q
);

reg q_pos, q_neg;

// Flip-flop triggered on positive edge
always @(posedge clk)
    q_pos <= d;

// Flip-flop triggered on negative edge
always @(negedge clk)
    q_neg <= d;

// Use the last triggered flip-flop's output
always @(posedge clk or negedge clk)
    if (clk)
        q <= q_pos;
    else
        q <= q_neg;

endmodule