module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

reg pos_edge_q, neg_edge_q;
reg prev_clk; // To detect clock edges

always @(posedge clk) pos_edge_q <= d;
always @(negedge clk) neg_edge_q <= d;

always @(*) begin
    if (clk) begin
        q = pos_edge_q;
    end else begin
        q = neg_edge_q;
    end
end

endmodule