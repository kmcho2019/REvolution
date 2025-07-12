module TopModule(
    input clk,
    input d,
    output reg q
);

// Use two flip-flops to capture input 'd' at both edges of the clock
reg q_pos;  // Positive-edge flip-flop output
reg q_neg;  // Negative-edge flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Output selection based on the current clock edge
assign q = clk ? q_pos : q_neg;

endmodule