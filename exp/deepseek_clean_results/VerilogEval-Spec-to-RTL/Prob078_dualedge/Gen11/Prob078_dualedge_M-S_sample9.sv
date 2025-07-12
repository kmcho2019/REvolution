module TopModule (
    input clk,
    input d,
    output q
);

    reg pos_edge_ff, neg_edge_ff;

    // Combined edge-triggered flip-flops
    always @(posedge clk, negedge clk) begin
        if (clk) pos_edge_ff <= d;  // Positive edge
        else     neg_edge_ff <= d;  // Negative edge
    end

    // Combinational output selection
    assign q = clk ? pos_edge_ff : neg_edge_ff;

endmodule