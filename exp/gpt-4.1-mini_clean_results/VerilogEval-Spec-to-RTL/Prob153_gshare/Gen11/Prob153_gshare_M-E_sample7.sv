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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    // 00: Strongly Not Taken, 01: Weakly Not Taken,
    // 10: Weakly Taken, 11: Strongly Taken
    reg [1:0] pht [0:127];

    // Global History Registers
    reg [6:0] ghr_commit;   // committed, stable history used for prediction output
    reg [6:0] ghr_spec;     // speculative history used internally

    // Registered prediction inputs to ensure timing correctness
    reg        predict_valid_r;
    reg [6:0]  predict_pc_r;

    // Compute indexes for prediction and training
    wire [6:0] predict_index = predict_pc_r ^ ghr_commit;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entry for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs
    assign predict_taken = predict_valid_r && pht_predict_entry[1];
    assign predict_history = ghr_commit;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state != 2'b11)
                    saturate_update = state + 2'b01;
                else
                    saturate_update = state;
            end else begin
                if (state != 2'b00)
                    saturate_update = state - 2'b01;
                else
                    saturate_update = state;
            end
        end
    endfunction

    integer i;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            // Initialize histories to zero
            ghr_commit <= 7'b0;
            ghr_spec <= 7'b0;
            // Clear prediction input registers
            predict_valid_r <= 1'b0;
            predict_pc_r <= 7'b0;
        end else begin
            // Register prediction inputs to align pipeline and stabilize index calculation
            predict_valid_r <= predict_valid;
            predict_pc_r <= predict_pc;

            // 1) Update PHT table at train_index if training valid
            if (train_valid)
                pht[train_index] <= saturate_update(pht[train_index], train_taken);

            // 2) Update speculative history with priority:
            //    If training and mispredicted, recover speculative history to train_history
            //    Else if prediction valid, update speculative history by shifting in predicted bit based on stable history
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit (MSB of saturating counter) from PHT entry at predict_index
                // Use committed history to shift for correct timing
                ghr_spec <= {ghr_commit[5:0], pht_predict_entry[1]};
            end
            // else keep ghr_spec unchanged

            // 3) Commit speculative history for next cycle
            ghr_commit <= ghr_spec;
        end
    end

endmodule