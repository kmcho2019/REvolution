module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for clock divider
reg clk_div;

// Clock divider to generate two out-of-phase clocks
always @(posedge clk) clk_div <= ~clk_div;

// Generate two clocks with opposite phases
wire clk_pos = clk;
wire clk_neg = ~clk;

// Single flip-flop triggered by one of the clocks
always @(posedge clk_pos) q <= d;

// Sample the input data at the negative edge of the original clock
reg q_neg;
always @(posedge clk_neg) q_neg <= d;

// Combinatorial logic to sample the output at both edges
assign q = (clk)? q : q_neg;

endmodule