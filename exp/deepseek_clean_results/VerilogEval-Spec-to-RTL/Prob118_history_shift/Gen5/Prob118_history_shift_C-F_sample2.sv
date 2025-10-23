module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;

    always @(posedge clk or posedge areset) begin
        // Priority: reset > misprediction correction > normal prediction update
        if (areset) begin
            history_reg <= 32'b0;  // Async reset clears history
        end else if (train_mispredicted) begin
            // On misprediction: restore history from train_history + actual outcome
            history_reg <= {train_history[30:0], train_taken};
        end else if (predict_valid) begin
            // Normal prediction: shift in new prediction bit
            history_reg <= {history_reg[30:0], predict_taken};
        end
        // No else: maintain current value if no updates
    end

    // Continuous assignment for output
    assign predict_history = history_reg;

endmodule