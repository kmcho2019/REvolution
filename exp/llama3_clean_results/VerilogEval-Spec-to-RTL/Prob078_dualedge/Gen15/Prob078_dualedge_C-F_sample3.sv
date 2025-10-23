module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for positive and negative edge flip-flops
reg q_pos;  
reg q_neg;  

// Positive-edge triggered flip-flop
always @(posedge clk) q_pos <= d;

// Negative-edge triggered flip-flop
always @(negedge clk) q_neg <= d;

// Directly assign the output based on the clock edge, minimizing additional logic
assign q = clk ? q_pos : q_neg;

endmodule