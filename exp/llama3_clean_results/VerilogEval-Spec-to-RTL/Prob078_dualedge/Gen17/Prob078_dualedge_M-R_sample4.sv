module TopModule(
    input clk,
    input d,
    output reg q
);

reg pos_edge_q;  
reg neg_edge_q;  

// Use a single always block to handle both positive and negative edges
always @(posedge clk, negedge clk) begin
    if (clk == 1'b1) begin
        pos_edge_q <= d;
    end else begin
        neg_edge_q <= d;
    end
end

// Directly assign the output based on the clock edge
assign q = (clk == 1'b1)? pos_edge_q : neg_edge_q;

endmodule