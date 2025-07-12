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

// HybridGShare predictor parameters
parameter HISTORY_BUFFER_SIZE = 16;
parameter PHT_SIZE = 128;

// History buffer
reg [6:0] history_buffer [HISTORY_BUFFER_SIZE-1:0];
reg [6:0] history_buffer_index;

// PHT
reg [1:0] pht [PHT_SIZE-1:0];

// Current branch history
reg [6:0] branch_history;

// Current prediction
reg predict_taken_reg;
reg [6:0] predict_history_reg;

// PHT index
reg [6:0] pht_index;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset history buffer
        for (int i = 0; i < HISTORY_BUFFER_SIZE; i++) begin
            history_buffer[i] <= 7'b0;
        end
        history_buffer_index <= 0;

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
        // Update history buffer
        if (train_valid) begin
            // Check if the branch is already in the history buffer
            reg [6:0] found_index;
            reg found;
            found <= 1'b0;
            for (int i = 0; i < HISTORY_BUFFER_SIZE; i++) begin
                if (history_buffer[i] == train_pc) begin
                    found_index <= i;
                    found <= 1'b1;
                    break;
                end
            end

            // If the branch is already in the history buffer, update its outcome
            if (found) begin
                // Update the outcome of the branch in the history buffer
                if (train_taken) begin
                    history_buffer[found_index] <= {history_buffer[found_index][5:0], 1'b1};
                end else begin
                    history_buffer[found_index] <= {history_buffer[found_index][5:0], 1'b0};
                end
            end else begin
                // If the branch is not in the history buffer, add it
                history_buffer[history_buffer_index] <= train_pc;
                if (train_taken) begin
                    history_buffer[history_buffer_index] <= {history_buffer[history_buffer_index][5:0], 1'b1};
                end else begin
                    history_buffer[history_buffer_index] <= {history_buffer[history_buffer_index][5:0], 1'b0};
                end
                history_buffer_index <= (history_buffer_index + 1) % HISTORY_BUFFER_SIZE;
            end

            // Update PHT
            pht_index <= (train_pc ^ train_history);
            if (train_taken) begin
                if (pht[pht_index] != 2'b11) begin
                    pht[pht_index] <= pht[pht_index] + 1;
                end
            end else begin
                if (pht[pht_index] != 2'b00) begin
                    pht[pht_index] <= pht[pht_index] - 1;
                end
            end

            // Recover branch history if misprediction
            if (train_mispredicted) begin
                branch_history <= train_history;
            end
        end

        // Make prediction
        if (predict_valid) begin
            // Check if the branch is in the history buffer
            reg [6:0] found_index;
            reg found;
            found <= 1'b0;
            for (int i = 0; i < HISTORY_BUFFER_SIZE; i++) begin
                if (history_buffer[i] == predict_pc) begin
                    found_index <= i;
                    found <= 1'b1;
                    break;
                end
            end

            // If the branch is in the history buffer, use its outcome to make a prediction
            if (found) begin
                if (history_buffer[found_index][6]) begin
                    predict_taken_reg <= 1'b1;
                end else begin
                    predict_taken_reg <= 1'b0;
                end
            end else begin
                // If the branch is not in the history buffer, use the PHT to make a prediction
                pht_index <= (predict_pc ^ branch_history);
                if (pht[pht_index] >= 2'b10) begin
                    predict_taken_reg <= 1'b1;
                end else begin
                    predict_taken_reg <= 1'b0;
                end
            end

            predict_history_reg <= branch_history;

            // Update branch history
            if (predict_taken_reg) begin
                branch_history <= {branch_history[5:0], 1'b1};
            end else begin
                branch_history <= {branch_history[5:0], 1'b0};
            end
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule