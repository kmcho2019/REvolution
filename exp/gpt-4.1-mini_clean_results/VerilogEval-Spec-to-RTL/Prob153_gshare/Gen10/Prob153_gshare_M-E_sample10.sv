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
    // 00 = Strongly Not Taken (SN)
    // 01 = Weakly Not Taken   (WN)
    // 10 = Weakly Taken       (WT)
    // 11 = Strongly Taken     (ST)

    reg [1:0] pht [0:127];

    // Global history registers:
    // ghr_committed: stable history used for prediction output and PHT indexing during cycle
    // ghr_updated: history after speculative prediction update (if any)
    // ghr_recovered: history recovered from mispredicted training branch (if any)
    reg [6:0] ghr_committed, ghr_updated, ghr_recovered;

    // Index calculation
    wire [6:0] predict_index = predict_pc ^ ghr_committed;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs
    assign predict_taken = (pht_predict_entry[1] == 1'b1);
    assign predict_history = ghr_committed;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = state;
                else
                    saturate_update = state + 1;
            end else begin
                if (state == 2'b00)
                    saturate_update = state;
                else
                    saturate_update = state - 1;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_committed <= 7'b0;
            ghr_updated <= 7'b0;
            ghr_recovered <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // 1. Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // 2. Compute recovered history for misprediction recovery
            if (train_valid && train_mispredicted) begin
                ghr_recovered <= train_history;
            end else begin
                ghr_recovered <= ghr_recovered; // hold value (not strictly necessary)
            end

            // 3. Compute updated speculative history for prediction update
            // Shift in predicted direction bit (MSB shifted out)
            ghr_updated <= {ghr_committed[5:0], pht_predict_entry[1]};

            // 4. Commit new global history with priority:
            //    a) If training with misprediction -> recover history
            //    b) Else if prediction valid -> commit updated history
            //    c) Else keep current committed history
            if (train_valid && train_mispredicted) begin
                ghr_committed <= train_history; // recover
            end else if (predict_valid) begin
                ghr_committed <= ghr_updated;   // update with predicted bit
            end else begin
                ghr_committed <= ghr_committed; // hold
            end
        end
    end

endmodule