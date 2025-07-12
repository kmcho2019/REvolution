module TopModule (
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

    // 2-bit saturating counter encoding (for clarity)
    localparam [1:0]
        SN = 2'b00, // Strong Not Taken
        WN = 2'b01, // Weak Not Taken
        WT = 2'b10, // Weak Taken
        ST = 2'b11; // Strong Taken

    // Pattern History Table: 128 entries (7-bit index), each 2-bit saturating counter
    reg [1:0] pht [0:127];

    // Global Branch History Register (7 bits)
    reg [6:0] ghr;

    // Prediction pipeline registers:
    // Store predicted taken bit and GHR sampled at prediction request cycle,
    // to update GHR on next cycle.
    reg        pred_taken_reg;
    reg [6:0]  pred_ghr_reg;
    reg        pred_valid_reg;

    // Compute prediction index from XOR of predict_pc and current GHR
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Compute training index from XOR of train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction and training
    wire [1:0] pht_predict = pht[predict_index];
    wire [1:0] pht_train   = (train_valid) ? pht[train_index] : 2'b00; 
    // pht_train used only if training valid, otherwise ignored

    // Prediction logic: taken if MSB of saturating counter = 1
    wire predict_taken_next = pht_predict[1];

    // Output predict_taken and predict_history reflect GHR and PHT state at prediction request
    assign predict_taken  = (predict_valid) ? predict_taken_next : 1'b0;
    assign predict_history = ghr;

    // Saturating counter increment (max 3)
    function [1:0] saturate_inc;
        input [1:0] val;
        begin
            saturate_inc = (val == ST) ? ST : val + 1'b1;
        end
    endfunction

    // Saturating counter decrement (min 0)
    function [1:0] saturate_dec;
        input [1:0] val;
        begin
            saturate_dec = (val == SN) ? SN : val - 1'b1;
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            pred_taken_reg <= 1'b0;
            pred_ghr_reg <= 7'b0;
            pred_valid_reg <= 1'b0;
            // Initialize all PHT entries to weak not taken (01)
            for (i=0; i<128; i=i+1) begin
                pht[i] <= WN;
            end
        end else begin
            // Prediction pipeline registers update:
            // When predict_valid asserted, latch prediction taken bit and current GHR
            pred_taken_reg <= predict_valid ? predict_taken_next : pred_taken_reg;
            pred_ghr_reg <= predict_valid ? ghr : pred_ghr_reg;
            pred_valid_reg <= predict_valid;

            // Update PHT on training (priority over prediction)
            if (train_valid) begin
                // Update saturating counter at train_index based on train_taken
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train);
                else
                    pht[train_index] <= saturate_dec(pht_train);
            end

            // Update GHR:
            // Priority:
            // 1) If training and mispredicted: restore GHR to train_history
            // 2) Else if prediction valid (previous cycle) update GHR with predicted bit from pipeline register
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (pred_valid_reg) begin
                // Shift left and append predicted taken bit from previous cycle
                ghr <= {ghr[5:0], pred_taken_reg};
            end
            // else keep ghr unchanged
        end
    end

endmodule