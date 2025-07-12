module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  // Output of positive-edge triggered flip-flop
reg neg_edge_q;  // Output of negative-edge triggered flip-flop

// Single always block to update pos_edge_q and neg_edge_q
always @(posedge clk or negedge clk) begin
    if (clk) begin
        pos_edge_q <= d;
    end else begin
        neg_edge_q <= d;
    end
    // Update output q based on the current state of the flip-flops and the clock edge
    q <= (clk)? pos_edge_q : neg_edge_q;
end

endmodule