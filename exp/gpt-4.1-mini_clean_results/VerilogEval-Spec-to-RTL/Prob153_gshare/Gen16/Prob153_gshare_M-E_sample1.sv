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
    reg [1:0] pht [0:127];

    // Committed global history register (reflects actual executed branches)
    reg [6:0] ghr_committed;

    // Speculative global history register (used for prediction)
    reg [6:0] ghr_spec;

    // History register captured at prediction time (to output as predict_history)
    reg [6:0] predict_history_reg;

    // Indexes
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT entries read asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction is 'taken' if MSB of saturating counter is 1 and predict_valid is asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    assign predict_history = predict_history_reg;

    // Saturating counter update function (2-bit saturating counter)
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Output the speculative global history used for prediction at predict_valid cycle
            if (predict_valid) begin
                predict_history_reg <= ghr_spec;
            end

            // Training updates
            if (train_valid) begin
                // Update PHT entry indexed by train_pc ^ train_history with actual branch outcome
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                // If misprediction: recover speculative history to committed history (train_history)
                if (train_mispredicted) begin
                    // Recover speculative history to committed history from train_history input
                    ghr_spec <= train_history;
                    ghr_committed <= train_history;
                end else begin
                    // On correct training, update committed GHR by shifting in actual branch outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Keep speculative history updated if no recovery
                    // Note: Do not update ghr_spec here; it will be updated by predictions or recovery only
                end
            end else begin
                // No training this cycle: Speculative history update on prediction
                if (predict_valid) begin
                    // Append predicted taken bit (MSB of PHT entry) to speculative history
                    ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
                end
                // No changes to committed history when no training
            end
        end
    end

endmodule