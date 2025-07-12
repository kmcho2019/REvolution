module TopModule(
    input  clk,
    input  areset,

    input  predict_valid,
    input  [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input  train_valid,
    input  train_taken,
    input  train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

reg [6:0] global_history;
reg [6:0] predict_history_reg;
reg [6:0] train_history_reg;

reg [6:0] pht_index;
reg [1:0] pht_entry;

reg predict_taken_reg;

// PHT (Pattern History Table)
reg [1:0] pht [127:0];

always @(*) begin
    // Calculate the index into the PHT
    pht_index = (predict_pc ^ global_history) % 128;

    // Read the PHT entry
    pht_entry = pht[pht_index];

    // Make a prediction based on the PHT entry
    if (pht_entry == 0 || pht_entry == 1)
        predict_taken_reg = 0;
    else
        predict_taken_reg = 1;

    predict_history_reg = global_history;
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset all registers
        global_history <= 0;
        predict_history_reg <= 0;
        train_history_reg <= 0;
        for (int i = 0; i < 128; i++)
            pht[i] <= 0;
    end
    else begin
        // Update the global history register
        if (train_valid && train_mispredicted) begin
            // If training for a misprediction, recover the branch history register
            global_history <= train_history;
        end
        else if (predict_valid) begin
            // If making a prediction, update the global history register
            global_history <= {global_history[5:0], predict_taken_reg};
        end

        // Update the PHT
        if (train_valid) begin
            // Calculate the index into the PHT
            reg [6:0] train_pht_index;
            train_pht_index = (train_pc ^ train_history) % 128;

            // Update the PHT entry
            if (train_taken) begin
                if (pht[train_pht_index] != 3)
                    pht[train_pht_index] <= pht[train_pht_index] + 1;
            end
            else begin
                if (pht[train_pht_index] != 0)
                    pht[train_pht_index] <= pht[train_pht_index] - 1;
            end
        end
    end
end

assign predict_taken = predict_taken_reg;
assign predict_history = predict_history_reg;

endmodule