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
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction outputs
    // Taken if MSB of saturating counter is 1, only when prediction is valid
    assign predict_taken = predict_valid && pht_predict_entry[1];
    // Output the speculative history used for prediction immediately
    assign predict_history = ghr_spec;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to Weakly Not Taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
        end else begin
            // Default: no changes to PHT entries or history registers
            // We'll update selectively below

            // Training has highest priority
            if (train_valid) begin
                // Saturating counter update for the indexed PHT entry (train_index)
                // Implement saturating counter inline:
                if (train_taken) begin
                    // Increment but saturate at 3
                    if (pht_train_entry != 2'b11)
                        pht[train_index] <= pht_train_entry + 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end else begin
                    // Decrement but saturate at 0
                    if (pht_train_entry != 2'b00)
                        pht[train_index] <= pht_train_entry - 2'b01;
                    else
                        pht[train_index] <= pht_train_entry;
                end

                if (train_mispredicted) begin
                    // On misprediction, recover global history to the post-branch state
                    ghr_committed <= train_history;
                    ghr_spec <= train_history;
                end else begin
                    // On correct training, update committed history with actual outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Speculative history is NOT updated here, prediction will do it
                end

            end else if (predict_valid) begin
                // No training this cycle, update speculative history by appending predicted bit
                // predicted bit = MSB of pht_predict_entry
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // Else no update to history or PHT
        end
    end

endmodule