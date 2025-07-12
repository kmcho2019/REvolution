module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
wire clk_neg = ~clk;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop
always @(posedge clk_neg) begin
    q_neg <= d;
end

// Output selection based on current clock state
assign q = clk ? q_pos : q_neg;

endmodule