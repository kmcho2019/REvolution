module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries, 2-bit saturating counters
    // States: 00 Strongly Not Taken, 01 Weakly Not Taken, 10 Weakly Taken, 11 Strongly Taken
    reg [1:0] pht [0:127];

    // Global History Register
    reg [6:0] ghr;

    // Registered addresses and data for PHT read and write ports to avoid read-write conflicts
    reg [6:0] predict_index_r; // Registered predict index to read PHT
    reg [6:0] train_index_r;   // Registered train index to update PHT
    reg        train_valid_r;
    reg        train_taken_r;

    // Combinational calculation of indexes
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries for prediction and training
    wire [1:0] pht_predict = pht[predict_index_r];
    wire [1:0] pht_train = pht[train_index_r];

    // Predicted bit for current prediction (most significant bit)
    wire predict_bit_comb = pht_predict[1];

    // Saturating counter update function
    function [1:0] sat_counter_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    sat_counter_update = 2'b11;
                else
                    sat_counter_update = state + 1;
            end else begin
                if (state == 2'b00)
                    sat_counter_update = 2'b00;
                else
                    sat_counter_update = state - 1;
            end
        end
    endfunction

    integer i;

    // Initialization on async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01; // weakly not taken
            ghr <= 7'b0;

            predict_taken <= 1'b0;
            predict_history <= 7'b0;

            predict_index_r <= 7'b0;
            train_index_r <= 7'b0;
            train_valid_r <= 1'b0;
            train_taken_r <= 1'b0;
        end else begin
            // Register input addresses and train data for this cycle
            predict_index_r <= predict_index;
            train_index_r <= train_index;
            train_valid_r <= train_valid;
            train_taken_r <= train_taken;

            // Update PHT entry on training, based on registered train_index and train_valid
            if (train_valid_r) begin
                pht[train_index_r] <= sat_counter_update(pht[train_index_r], train_taken_r);
            end

            // Priority for GHR update:
            // 1) If training mispredicted, recover GHR to train_history
            // 2) Else if prediction valid and no training mispredict this cycle, update GHR with predicted bit
            // Note that train_mispredicted is synchronous and valid this cycle, prioritize that
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_bit_comb};
            end else begin
                ghr <= ghr;
            end

            // Register prediction outputs from stable PHT and GHR values (registered predict_index_r)
            // Only update outputs when predict_valid asserted to avoid glitches
            if (predict_valid) begin
                predict_taken <= predict_bit_comb;
                predict_history <= ghr;
            end else begin
                predict_taken <= predict_taken;
                predict_history <= predict_history;
            end
        end
    end

endmodule