module TopModule (
    input clk,
    input d,
    output reg q
);
    reg d_pos;        // Sample of d on posedge clk
    reg q_neg_edge;   // Toggles on negedge clk if d changes

    // Sample input d on positive edge of clk
    always @(posedge clk) begin
        d_pos <= d;
    end

    // Toggle q_neg_edge on negative edge if sampled data changed
    always @(negedge clk) begin
        if (d_pos != q_neg_edge)
            q_neg_edge <= d_pos;
    end

    // Output q follows q_neg_edge (which updated on negedge)
    always @(posedge clk) begin
        q <= q_neg_edge;
    end
endmodule