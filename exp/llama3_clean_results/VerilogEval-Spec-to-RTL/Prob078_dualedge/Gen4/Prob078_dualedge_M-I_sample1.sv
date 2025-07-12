module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals
reg clk180; // 180-degree phase-shifted clock
reg pos_edge_q; // Output of positive-edge triggered flip-flop
reg neg_edge_q; // Output of the flip-flop triggered by the opposite phase of the clock

// Generate 180-degree phase-shifted clock
always @(posedge clk)
    clk180 <= ~clk180;

// Positive-edge triggered flip-flop
always @(posedge clk)
    pos_edge_q <= d;

// Flip-flop triggered by the opposite phase of the clock (simulating negative-edge triggering)
always @(posedge clk180)
    neg_edge_q <= d;

// Output selection logic
always @(posedge clk or posedge clk180)
    if (clk)
        q <= pos_edge_q;
    else
        q <= neg_edge_q;

endmodule