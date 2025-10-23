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

    // Registered output of predict_history (history state used to make the prediction)
    reg [6:0] predict_history_reg;

    // Indexes for PHT access
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index = train_pc ^ train_history;

    // Asynchronous reads of PHT entries
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction output logic: taken if MSB of saturating counter is 1 and predict_valid is asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    assign predict_history = predict_history_reg;

    // Saturating counter update function for 2-bit counters
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
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr_committed <= 7'b0;
            ghr_spec <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Priority: training updates take precedence over prediction updates

            if (train_valid) begin
                // Update the PHT entry indexed by train_pc ^ train_history with actual outcome
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On misprediction training, recover speculative and committed history to train_history input
                    ghr_committed <= train_history;
                    ghr_spec <= train_history;
                end else begin
                    // On correct training, update committed history by shifting in actual branch outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Do not update speculative history here; prediction updates it later
                end

                // When training occurs, prediction in same cycle does not update speculative history
                // However, output predict_history as previous speculative history if prediction valid
                if (predict_valid) begin
                    predict_history_reg <= ghr_spec;
                end

            end else begin
                // No training this cycle

                if (predict_valid) begin
                    // Output the speculative history used to make prediction (before update)
                    predict_history_reg <= ghr_spec;
                    // Update speculative history by shifting in predicted bit at next clock edge
                    ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
                end
                // If no prediction and no training, no changes to histories or predict_history_reg
            end
        end
    end

endmodule