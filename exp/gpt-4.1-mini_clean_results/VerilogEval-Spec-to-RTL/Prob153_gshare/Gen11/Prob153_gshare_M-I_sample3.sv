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

    // 2-bit saturating counter states:
    // 00 = Strongly Not Taken
    // 01 = Weakly Not Taken
    // 10 = Weakly Taken
    // 11 = Strongly Taken

    reg [1:0] pht [0:127];

    reg [6:0] ghr_reg;    // committed global history
    reg [6:0] ghr_spec;   // speculative global history updated on prediction/training

    // Register prediction inputs to align outputs
    reg         predict_valid_r;
    reg  [6:0]  predict_pc_r;

    // Prediction index uses committed global history (stable this cycle)
    wire [6:0] predict_index = predict_pc_r ^ ghr_reg;

    // Training index uses train inputs
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction (before training update at posedge)
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Predict outputs
    assign predict_taken = (predict_valid_r) ? (pht_predict_entry[1]) : 1'b0;
    assign predict_history = (predict_valid_r) ? ghr_reg : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = state;
                else
                    saturate_update = state + 2'b01;
            end else begin
                if (state == 2'b00)
                    saturate_update = state;
                else
                    saturate_update = state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_reg       <= 7'b0;
            ghr_spec      <= 7'b0;
            predict_valid_r <= 1'b0;
            predict_pc_r    <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // Register prediction inputs to align outputs
            predict_valid_r <= predict_valid;
            predict_pc_r    <= predict_pc;

            // 1. Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // 2. Update speculative global history with priority:
            //    a) If train_valid && train_mispredicted: recover to train_history
            //    b) Else if predict_valid: update by shifting in predicted taken bit (from pre-update pht)
            //    c) Else hold current speculative history

            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Use committed ghr_reg for updating speculative history
                // Predicted bit is MSB of pht_predict_entry (taken bit)
                ghr_spec <= {ghr_reg[5:0], pht_predict_entry[1]};
            end else begin
                ghr_spec <= ghr_spec; // hold
            end

            // 3. Commit speculative history for next cycle's prediction
            ghr_reg <= ghr_spec;
        end
    end

endmodule