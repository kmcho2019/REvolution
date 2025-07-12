module TopModule (
    input          clk,
    input          areset,
    input          predict_valid,
    input          predict_taken,
    input          train_mispredicted,
    input          train_taken,
    input  [31:0]  train_history,
    output [31:0]  predict_history
);

    reg [31:0] history_reg;    // main history register
    reg [31:0] shadow_reg;     // holds history before current predicted branch

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
            shadow_reg  <= 32'b0;
        end else if (train_mispredicted) begin
            // On misprediction: rollback history to corrected branch outcome
            history_reg <= {train_history[30:0], train_taken};
            shadow_reg  <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // On prediction: shift in new prediction bit, save old history to shadow
            shadow_reg  <= history_reg;
            history_reg <= {history_reg[30:0], predict_taken};
        end
        // else maintain current state (no update)
    end

    assign predict_history = history_reg;

endmodule