module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global branch history registers
    reg [6:0] ghr_committed; // committed global history (true history)
    reg [6:0] ghr_spec;      // speculative global history (used for predictions)

    // Compute PHT indices by XORing PC and history
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction outputs
    // Only valid prediction outputs taken from MSB of saturating counter when predict_valid asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    // Output speculative history used to produce this prediction
    assign predict_history = ghr_spec;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            // Reset histories
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
        end else begin
            // --- TRAINING UPDATE (highest priority) ---
            if (train_valid) begin
                // Update PHT entry at train_index
                if (train_taken) begin
                    // Increment saturating counter unless at max (3)
                    if (pht_train_entry != 2'b11)
                        pht[train_index] <= pht_train_entry + 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end else begin
                    // Decrement saturating counter unless at min (0)
                    if (pht_train_entry != 2'b00)
                        pht[train_index] <= pht_train_entry - 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end

                if (train_mispredicted) begin
                    // On misprediction: recover committed and speculative history to train_history (post-branch state)
                    ghr_committed <= train_history;
                    ghr_spec <= train_history;
                end else begin
                    // On correct training: update committed history by shifting in actual outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Do NOT update speculative history here; speculation remains until prediction update
                    // This preserves speculation consistency on non-mispredicted training cycles
                end

            end else if (predict_valid) begin
                // --- PREDICTION UPDATE (only if no training in same cycle) ---
                // Update speculative history by shifting in predicted bit (MSB of pht_predict_entry)
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
                // committed history remains unchanged here
            end
            // If neither training nor prediction valid, no change to histories or PHT
        end
    end

endmodule