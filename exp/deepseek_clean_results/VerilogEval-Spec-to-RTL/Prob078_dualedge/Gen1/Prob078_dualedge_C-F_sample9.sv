module TopModule (
    input clk,
    input d,
    output q
);

reg q_pos, q_neg;
wire clk_buf;

// Clock buffer for better clock distribution
BUFG clk_buffer (.I(clk), .O(clk_buf));

// Positive edge triggered flip-flop
always @(posedge clk_buf) begin
    q_pos <= d;
end

// Negative edge triggered flip-flop
always @(negedge clk_buf) begin
    q_neg <= d;
end

// Output selection based on current clock state
assign q = clk_buf ? q_pos : q_neg;

endmodule