module TopModule (
    input clk,
    input d,
    output reg q
);

    reg pos_ff, neg_ff;
    reg last_d;
    wire data_changed = (d != last_d);
    wire gated_clk = clk & data_changed;

    // Positive edge capture
    always @(posedge clk) begin
        pos_ff <= d;
        last_d <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        neg_ff <= d;
    end

    // Registered output with clock gating
    always @(posedge gated_clk) begin
        q <= clk ? pos_ff : neg_ff;
    end

endmodule