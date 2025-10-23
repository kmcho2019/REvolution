module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output reg q // Output of the dual-edge triggered flip-flop
);

// Internal signals for positive and negative edge flip-flops
reg pos_edge_q;  // Positive edge flip-flop output
reg neg_edge_q;  // Negative edge flip-flop output

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d; // Capture data on positive edge of clk
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d; // Capture data on negative edge of clk
end

// Output logic: Select between positive and negative edge flip-flop outputs based on clk
assign q = (clk)? pos_edge_q : neg_edge_q;

endmodule