module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

    // 2-bit saturating counter states:
    // 2'b00: strongly not taken
    // 2'b01: weakly not taken
    // 2'b10: weakly taken
    // 2'b11: strongly taken

    // PHT: 128 entries of 2-bit counters
    reg [1:0] pht [0:127];

    // Global history register (7 bits)
    reg [6:0] global_history;

    // Index calculation function
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction
    wire [1:0] pht_entry = pht[predict_index];

    // Prediction: taken if MSB of counter is 1
    assign predict_taken = (pht_entry[1] == 1'b1);
    assign predict_history = global_history;

    integer i;

    // Next global history value after prediction update
    wire predicted_dir = predict_taken;
    wire [6:0] next_global_history_pred = {global_history[5:0], predicted_dir};

    // Next global history value after training update (if mispredicted)
    // If mispredicted, restore global history to train_history
    // Otherwise, no change to global history from training
    wire [6:0] next_global_history_train = train_mispredicted ? train_history : global_history;

    // PHT update logic for training
    // Update happens on posedge clk
    // Saturating counter update:
    // If train_taken=1, increment counter (max 3)
    // else decrement counter (min 0)
    reg [1:0] pht_entry_train;
    always @(*) begin
        pht_entry_train = pht[train_index];
        if (train_valid) begin
            if (train_taken) begin
                if (pht_entry_train != 2'b11)
                    pht_entry_train = pht_entry_train + 1'b1;
            end else begin
                if (pht_entry_train != 2'b00)
                    pht_entry_train = pht_entry_train - 1'b1;
            end
        end
    end

    // On clock edge: update PHT and global history
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset global history and PHT entries
            global_history <= 7'b0;
            for (i=0; i<128; i=i+1) begin
                // Initialize counters to weakly taken (2'b10)
                pht[i] <= 2'b10;
            end
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= pht_entry_train;
            end

            // Update global history:
            // If train_valid & train_mispredicted: restore to train_history
            // Else if predict_valid: update with predicted direction
            // If both train_mispredicted and predict_valid in same cycle, training takes precedence
            if (train_valid && train_mispredicted) begin
                global_history <= train_history;
            end else if (predict_valid) begin
                global_history <= next_global_history_pred;
            end
            // else no change to global_history
        end
    end

endmodule