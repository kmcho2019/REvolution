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

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history registers
    reg [6:0] ghr_committed; // history committed after resolved branches
    reg [6:0] ghr_spec;      // speculative history used for prediction

    // Compute PHT indices
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally (read-before-write semantics)
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry   = pht[train_index];

    // Prediction outputs
    // Taken if MSB of saturating counter is 1, valid only when predict_valid asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    // Output speculative history used for prediction immediately
    assign predict_history = ghr_spec;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Taken (2'b10)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b10;
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
        end else begin
            // Default no change to entries except targeted ones
            // Handle training first (highest priority)
            if (train_valid) begin
                // Update saturating counter for train_index
                if (train_taken) begin
                    // Increment saturating counter saturating at 3
                    if (pht_train_entry != 2'b11)
                        pht[train_index] <= pht_train_entry + 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end else begin
                    // Decrement saturating counter saturating at 0
                    if (pht_train_entry != 2'b00)
                        pht[train_index] <= pht_train_entry - 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end

                if (train_mispredicted) begin
                    // On mispredict, recover committed and speculative history to train_history
                    ghr_committed <= train_history;
                    ghr_spec <= train_history;
                end else begin
                    // On correct training, update committed history with actual branch outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Do NOT update speculative history on training (prediction does it)
                    // So ghr_spec remains unchanged here
                end

            end else if (predict_valid) begin
                // No training this cycle: update speculative history with predicted bit
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
                // committed history unchanged
            end
            // Else no update to histories or PHT
        end
    end

endmodule