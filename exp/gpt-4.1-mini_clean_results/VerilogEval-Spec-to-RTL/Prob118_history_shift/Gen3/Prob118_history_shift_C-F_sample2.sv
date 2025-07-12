module TopModule (
    input         clk,
    input         areset,
    input         predict_valid,
    input         predict_taken,
    input         train_mispredicted,
    input         train_taken,
    input  [31:0] train_history,
    output [31:0] predict_history
);

    reg [32:0] history_reg;
    wire       update_en;

    // Enable updates only on misprediction or valid prediction to save power
    assign update_en = train_mispredicted | predict_valid;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 33'b0;
        end else if (update_en) begin
            if (train_mispredicted) begin
                // Rollback: load train_history concatenated with actual outcome train_taken
                history_reg <= {train_history, train_taken};
            end else begin
                // Shift left by 1, insert predicted taken bit at LSB
                history_reg <= {history_reg[31:0], predict_taken};
            end
        end
        // else hold state without toggling to save power
    end

    // Output the lower 32 bits as the current global history with youngest branch at bit 0
    assign predict_history = history_reg[31:0];

endmodule