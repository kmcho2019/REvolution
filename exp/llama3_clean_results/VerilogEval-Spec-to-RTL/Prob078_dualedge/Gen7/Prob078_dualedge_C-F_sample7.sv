module TopModule(
    input clk,
    input d,
    output reg q
);

// Outputs of the positive-edge and negative-edge triggered flip-flops
reg q_pos;
reg q_neg;

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q_neg <= d;
end

// Continuous assignment to select the output based on the clock edge
assign q = (clk == 1'b1) ? q_pos : q_neg;

endmodule