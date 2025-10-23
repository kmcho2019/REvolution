module TopModule (
    input clk,
    input d,
    output reg q
);

reg pos_q, neg_q;
reg d_prev;

// Store previous input for change detection
always @(posedge clk) begin
    d_prev <= d;
end

// Positive edge triggered flip-flop with enable
always @(posedge clk) begin
    if (d != d_prev) pos_q <= d;
    // Optional synchronous reset: if (reset) pos_q <= 1'b0;
end

// Negative edge triggered flip-flop with enable
always @(negedge clk) begin
    if (d != d_prev) neg_q <= d;
    // Optional synchronous reset: if (reset) neg_q <= 1'b0;
end

// Output stage - clock-gated latch instead of mux
always @(*) begin
    if (clk) q = pos_q;
    else q = neg_q;
end

endmodule