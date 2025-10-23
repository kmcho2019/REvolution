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

    // Saturating counter encoding
    localparam [1:0]
        SN = 2'b00, // Strongly Not Taken
        WN = 2'b01, // Weakly Not Taken
        WT = 2'b10, // Weakly Taken
        ST = 2'b11; // Strongly Taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history registers:
    // committed_ghr: last committed history (after executing branches)
    // speculative_ghr: speculative history updated after predictions
    reg [6:0] committed_ghr;
    reg [6:0] speculative_ghr;

    // Index calculation wires
    wire [6:0] predict_index = predict_pc ^ speculative_ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // PHT read for prediction (combinational)
    wire [1:0] predict_counter = pht[predict_index];
    wire       predicted_taken_bit = predict_counter[1];

    // Outputs: when predict_valid is high,
    // predict_history is the speculative_ghr BEFORE updating it with predicted outcome,
    // i.e. the history state used for making the prediction.
    assign predict_taken   = predict_valid ? predicted_taken_bit : 1'b0;
    assign predict_history = predict_valid ? speculative_ghr : 7'b0;

    // Saturating counter increment function
    function [1:0] saturate_inc(input [1:0] val);
        case(val)
            SN: saturate_inc = WN;
            WN: saturate_inc = WT;
            WT: saturate_inc = ST;
            ST: saturate_inc = ST;
            default: saturate_inc = val;
        endcase
    endfunction

    // Saturating counter decrement function
    function [1:0] saturate_dec(input [1:0] val);
        case(val)
            ST: saturate_dec = WT;
            WT: saturate_dec = WN;
            WN: saturate_dec = SN;
            SN: saturate_dec = SN;
            default: saturate_dec = val;
        endcase
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to Weakly Taken (WT)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WT;
            end
            committed_ghr  <= 7'b0;
            speculative_ghr <= 7'b0;
        end else begin
            // 1) Training updates PHT at train_index if train_valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // 2) Handle history register updates and recovery
            if (train_valid && train_mispredicted) begin
                // On mispredict training: recover speculative_ghr to train_history
                speculative_ghr <= train_history;
                // committed_ghr remains as last committed point (not shifted here)
                // The pipeline will flush, so speculative history is restored
            end else if (train_valid && !train_mispredicted) begin
                // Correct prediction training:
                // Update committed history by shifting in actual outcome
                committed_ghr <= {committed_ghr[5:0], train_taken};
                // Speculative history unchanged here (already updated by predictions)
            end

            // 3) Prediction updates speculative_ghr by shifting in predicted bit
            // Only update speculative_ghr after training logic to give training precedence
            if (predict_valid) begin
                // Only update speculative_ghr if no misprediction recovery in this cycle
                if (!(train_valid && train_mispredicted)) begin
                    speculative_ghr <= {speculative_ghr[5:0], predicted_taken_bit};
                end
                // Else speculative_ghr was recovered above, no update here
            end
        end
    end

endmodule