module TopModule (
    input        clk,
    input        areset,

    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // Local parameters for 2-bit saturating counters
    localparam [1:0] STRONG_NOT_TAKEN = 2'b00;
    localparam [1:0] WEAK_NOT_TAKEN   = 2'b01;
    localparam [1:0] WEAK_TAKEN       = 2'b10;
    localparam [1:0] STRONG_TAKEN     = 2'b11;

    // Pattern History Table: 128 entries of 2-bit counters
    reg [1:0] pht [0:127];

    // Global history registers:
    // - ghr_predict: history used for prediction, updated after prediction
    // - ghr_train: history used for training recovery and updated on training
    reg [6:0] ghr_predict;
    reg [6:0] ghr_train;

    // Combinational logic: prediction index from predict_pc ^ ghr_predict
    wire [6:0] predict_index = predict_pc ^ ghr_predict;

    // Read the saturating counter from PHT for prediction index
    wire [1:0] pht_predict = pht[predict_index];

    // Prediction is taken if MSB of saturating counter is 1
    wire predict_taken_comb = pht_predict[1];

    // Assign output combinationally from current ghr_predict and prediction result
    assign predict_taken  = (predict_valid) ? predict_taken_comb : 1'b0;
    assign predict_history = (predict_valid) ? ghr_predict : 7'b0;

    // Functions to saturate counters increment/decrement
    function [1:0] saturate_inc(input [1:0] val);
        begin
            saturate_inc = (val == STRONG_TAKEN) ? STRONG_TAKEN : val + 2'b01;
        end
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        begin
            saturate_dec = (val == STRONG_NOT_TAKEN) ? STRONG_NOT_TAKEN : val - 2'b01;
        end
    endfunction

    // Compute training PHT index from train_pc ^ train_history
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to WEAK_NOT_TAKEN (01) as a neutral starting point
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WEAK_NOT_TAKEN;
            end
            // Initialize both GHRs to zero
            ghr_predict <= 7'b0;
            ghr_train   <= 7'b0;
        end else begin
            // 1) Update PHT only on valid training
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // 2) Handle misprediction training recovery:
            //    - On misprediction, recover ghr_train to train_history
            //    - Also update ghr_predict to train_history to discard speculative history
            if (train_valid && train_mispredicted) begin
                ghr_train <= train_history;
                ghr_predict <= train_history;
            end else begin
                // 3) If no misprediction training recovery:
                //    - Update ghr_train on training branch outcome (shift in actual train_taken)
                //    - Update ghr_predict on prediction (shift in predicted bit)
                if (train_valid) begin
                    // Update ghr_train with actual outcome of training branch
                    ghr_train <= {ghr_train[5:0], train_taken};
                end
                if (predict_valid) begin
                    // Update ghr_predict with predicted branch direction
                    ghr_predict <= {ghr_predict[5:0], predict_taken_comb};
                end
            end
        end
    end

endmodule