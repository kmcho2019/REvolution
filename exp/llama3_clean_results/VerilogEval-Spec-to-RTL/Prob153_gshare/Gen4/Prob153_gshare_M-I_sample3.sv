module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Gshare predictor parameters
parameter PHT_SIZE = 128;

// PHT
reg [1:0] pht [PHT_SIZE-1:0];

// Current branch history
reg [6:0] branch_history;

// Current prediction
reg predict_taken_reg;
reg [6:0] predict_history_reg;

// PHT index
reg [6:0] pht_index;

// Temporary variables for updating PHT and branch history
reg [1:0] pht_update;
reg [6:0] branch_history_update;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset PHT
        for (int i = 0; i < PHT_SIZE; i++) begin
            pht[i] <= 2'b0;
        end

        // Reset branch history
        branch_history <= 7'b0;

        // Reset prediction
        predict_taken_reg <= 1'b0;
        predict_history_reg <= 7'b0;
    end else begin
        // Update PHT and branch history
        if (train_valid) begin
            // Calculate PHT index
            pht_index <= (train_pc ^ train_history);

            // Update PHT
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht_update <= pht[pht_index] + 1;
                end else begin
                    pht_update <= pht[pht_index];
                end
            end else begin
                if (pht[pht_index] != 2'b00) begin
                    pht_update <= pht[pht_index] - 1;
                end else begin
                    pht_update <= pht[pht_index];
                end
            end

            // Update PHT
            pht[pht_index] <= pht_update;

            // Recover branch history if misprediction
            if (train_mispredicted) begin
                branch_history_update <= train_history;
            end else begin
                branch_history_update <= branch_history;
            end
        end else begin
            // No training, just update PHT and branch history based on prediction
            if (predict_valid) begin
                // Calculate PHT index
                pht_index <= (predict_pc ^ branch_history);

                // Make prediction
                if (pht[pht_index] >= 2'b10) begin
                    predict_taken_reg <= 1'b1;
                end else begin
                    predict_taken_reg <= 1'b0;
                end

                predict_history_reg <= branch_history;

                // Update branch history
                if (predict_taken_reg) begin
                    branch_history_update <= {branch_history[5:0], 1'b1};
                end else begin
                    branch_history_update <= {branch_history[5:0], 1'b0};
                end
            end else begin
                // No prediction, just keep the current branch history
                branch_history_update <= branch_history;
            end
        end

        // Update branch history
        branch_history <= branch_history_update;
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule