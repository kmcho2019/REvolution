module TopModule (
    input clk,
    input d,
    output reg q
);

    reg pos_q, neg_q;
    wire pos_clk_en, neg_clk_en;

    // Clock gating control
    assign pos_clk_en = clk;      // Active during high phase
    assign neg_clk_en = ~clk;     // Active during low phase

    // Positive edge triggered flip-flop with gating
    always @(posedge clk) begin
        if (pos_clk_en) begin
            pos_q <= d;
        end
    end

    // Negative edge triggered flip-flop with gating
    always @(negedge clk) begin
        if (neg_clk_en) begin
            neg_q <= d;
        end
    end

    // Synchronized output selection
    always @(posedge clk) begin
        q <= pos_q;
    end
    
    always @(negedge clk) begin
        q <= neg_q;
    end

endmodule