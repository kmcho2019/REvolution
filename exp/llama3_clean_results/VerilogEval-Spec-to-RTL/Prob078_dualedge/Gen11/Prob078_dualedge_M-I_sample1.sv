module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  // Output of positive-edge triggered flip-flop
reg neg_edge_q;  // Output of negative-edge triggered flip-flop

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// To optimize, ensure q is correctly updated on both edges without introducing additional logic
always @(posedge clk or negedge clk) begin
    if (clk) begin
        q <= pos_edge_q;
    end else begin
        q <= neg_edge_q;
    end
end

endmodule