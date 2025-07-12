module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for positive and negative edge flip-flops
reg q_pos;
reg q_neg;

// Always blocks for positive and negative edge triggered flip-flops
always @(posedge clk) begin
    q_pos <= d;
end

always @(negedge clk) begin
    q_neg <= d;
end

// Output selection based on current clock edge
assign q = clk? q_pos : q_neg;

endmodule