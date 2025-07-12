module TopModule(
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;
    reg        gated_clk_en;

    // Clock gating enable signal - update only when misprediction or valid prediction
    always @(*) begin
        gated_clk_en = train_mispredicted | predict_valid;
    end

    // Update history on gated clock enable, priority to misprediction
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else if (gated_clk_en) begin
            if (train_mispredicted) begin
                // Load history after rollback: previous history + actual branch taken
                history <= {train_history[30:0], train_taken};
            end else begin
                // Shift in predicted taken bit on valid prediction
                history <= {history[30:0], predict_taken};
            end
        end
    end

    assign predict_history = history;

endmodule