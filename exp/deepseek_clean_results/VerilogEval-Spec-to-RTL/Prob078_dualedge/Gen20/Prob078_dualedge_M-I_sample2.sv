module TopModule (
    input clk,
    input d,
    output reg q
);

    reg pos_edge_ff, neg_edge_ff;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        pos_edge_ff <= d;
    end

    // Negative edge triggered flip-flop
    always @(negedge clk) begin
        neg_edge_ff <= d;
    end

    // Output selection with balanced timing
    always @(*) begin
        q = clk ? pos_edge_ff : neg_edge_ff;
    end

endmodule