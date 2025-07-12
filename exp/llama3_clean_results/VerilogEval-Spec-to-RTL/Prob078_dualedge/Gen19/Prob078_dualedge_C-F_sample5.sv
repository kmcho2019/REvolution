module TopModule(
    input clk,  
    input d,    
    output reg q 
);

reg pos_edge_q, neg_edge_q;

// Positive edge flip-flop
always @(posedge clk) begin
    pos_edge_q <= d;
end

// Negative edge flip-flop
always @(negedge clk) begin
    neg_edge_q <= d;
end

// Output selection based on current clock edge
assign q = clk ? pos_edge_q : neg_edge_q;

endmodule