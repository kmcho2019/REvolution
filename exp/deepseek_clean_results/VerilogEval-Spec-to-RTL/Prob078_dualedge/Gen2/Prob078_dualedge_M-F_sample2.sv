module TopModule (
    input clk,
    input d,
    output q
);

reg pos_q, neg_q;

// Positive edge triggered flip-flop
always @(posedge clk) begin
    pos_q <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk) begin
    neg_q <= d;
end

// Output selection based on current clock state
assign q = clk ? pos_q : neg_q;

endmodule