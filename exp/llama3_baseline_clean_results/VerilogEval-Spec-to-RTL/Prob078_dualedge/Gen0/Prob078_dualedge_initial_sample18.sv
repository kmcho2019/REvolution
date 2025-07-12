module TopModule(
    input clk,
    input d,
    output q
);

reg q_reg;
reg q1_reg;
reg q2_reg;

// Positive edge triggered flip-flop
always @(posedge clk)
    q1_reg <= d;

// Negative edge triggered flip-flop
always @(negedge clk)
    q2_reg <= d;

// Select between the two flip-flops based on the clock edge
always @(posedge clk or negedge clk)
    q_reg <= (clk) ? q1_reg : q2_reg;

// Assign the output
assign q = q_reg;

endmodule