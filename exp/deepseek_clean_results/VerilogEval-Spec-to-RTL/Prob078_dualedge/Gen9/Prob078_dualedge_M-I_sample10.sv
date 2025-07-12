module TopModule (
    input clk,
    input d,
    output reg q
);

    reg pos_ff, neg_ff;
    reg last_pos, last_neg;
    wire data_changed;
    wire mux_out;

    // Positive edge capture
    always @(posedge clk) begin
        pos_ff <= d;
        last_pos <= d;
    end

    // Negative edge capture
    always @(negedge clk) begin
        neg_ff <= d;
        last_neg <= d;
    end

    // Detect when data changes between edges
    assign data_changed = (last_pos != last_neg);

    // Clock-driven output selection with gating
    assign mux_out = (data_changed) ? (clk ? pos_ff : neg_ff) : q;

    // Registered output for better timing
    always @(posedge clk) begin
        q <= mux_out;
    end

endmodule