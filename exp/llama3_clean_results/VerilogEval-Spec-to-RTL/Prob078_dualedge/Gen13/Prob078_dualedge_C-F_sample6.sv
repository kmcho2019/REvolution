module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for positive and negative edge flip-flops
reg pos_edge_q;  
reg neg_edge_q;  

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// Directly assign the output based on the clock edge, minimizing additional logic
assign q = (clk == 1'b1)? pos_edge_q : neg_edge_q;

endmodule