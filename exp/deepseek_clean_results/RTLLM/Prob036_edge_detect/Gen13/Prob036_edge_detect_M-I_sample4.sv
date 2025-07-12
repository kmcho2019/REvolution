module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

    reg a_prev;
    reg a_stable;  // Indicates when input hasn't changed
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
            a_stable <= 1'b1;
        end
        else begin
            // Clock gating logic
            if (a != a_prev) begin
                a_prev <= a;
                rise <= a & ~a_prev;
                down <= ~a & a_prev;
                a_stable <= 1'b0;
            end
            else begin
                rise <= 1'b0;
                down <= 1'b0;
                a_stable <= 1'b1;
            end
        end
    end

    // Optional: Actual clock gating would be implemented with technology cells
    // This is conceptual representation
    wire gated_clk = clk & ~a_stable;
    // In real implementation, use library clock gating cells

endmodule