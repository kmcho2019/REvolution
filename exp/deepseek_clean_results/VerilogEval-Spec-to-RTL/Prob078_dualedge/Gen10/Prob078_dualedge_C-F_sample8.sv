module TopModule (
    input clk,
    input d,
    output q
);

    reg pos_edge_ff, neg_edge_ff;
    wire neg_clk = ~clk;

    // Positive edge triggered flip-flop
    always @(posedge clk) begin
        pos_edge_ff <= d;
    end

    // Negative edge triggered flip-flop (using inverted clock)
    always @(posedge neg_clk) begin
        neg_edge_ff <= d;
    end

    // Combinational output selection
    assign q = clk ? pos_edge_ff : neg_edge_ff;

endmodule