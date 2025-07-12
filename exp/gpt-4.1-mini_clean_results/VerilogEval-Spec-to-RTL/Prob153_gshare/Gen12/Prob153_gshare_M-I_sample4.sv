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

    // Saturating counter states encoding
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers:
    // prediction_ghr is the GHR used for prediction in current cycle (stable for outputs)
    // committed_ghr reflects the GHR after last commit (training or recovery)
    reg [6:0] prediction_ghr;
    reg [6:0] committed_ghr;

    // Compute indices combinationally
    wire [6:0] predict_index = predict_pc ^ prediction_ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT state for prediction (combinational read port)
    wire [1:0] predict_counter = pht[predict_index];

    // Prediction output: taken if MSB of saturating counter is 1
    wire predicted_taken_bit = predict_counter[1];

    // Output prediction signals only valid if predict_valid, else 0
    assign predict_taken   = predict_valid ? predicted_taken_bit : 1'b0;
    assign predict_history = predict_valid ? prediction_ghr : 7'b0;

    // Saturating counter increment function
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case (val)
                SN: saturate_inc = WN;
                WN: saturate_inc = WT;
                WT: saturate_inc = ST;
                ST: saturate_inc = ST;
                default: saturate_inc = val;
            endcase
        end
    endfunction

    // Saturating counter decrement function
    function [1:0] saturate_dec(input [1:0] val);
        begin
            case (val)
                ST: saturate_dec = WT;
                WT: saturate_dec = WN;
                WN: saturate_dec = SN;
                SN: saturate_dec = SN;
                default: saturate_dec = val;
            endcase
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset GHRs and PHT entries
            prediction_ghr <= 7'b0;
            committed_ghr  <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN; // Initialize to Weakly Not Taken
            end
        end else begin
            // 1) Update PHT if training valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // 2) Determine new GHR values with correct priority
            // Temporary registers to hold next state of GHRs
            reg [6:0] next_prediction_ghr;
            reg [6:0] next_committed_ghr;

            next_prediction_ghr = prediction_ghr; // default no change
            next_committed_ghr  = committed_ghr;  // default no change

            if (train_valid && train_mispredicted) begin
                // On misprediction, recover history for flush:
                // Both committed and prediction GHRs set to train_history
                next_committed_ghr  = train_history;
                next_prediction_ghr = train_history;
            end else if (predict_valid) begin
                // Otherwise, if prediction valid, shift predicted taken bit into prediction_ghr
                // committed_ghr stays same this cycle (only updated on train commits)
                next_prediction_ghr = {prediction_ghr[5:0], predicted_taken_bit};
                // committed_ghr unchanged
            end
            // else no changes to GHRs

            // Commit GHR updates at end of cycle
            prediction_ghr <= next_prediction_ghr;
            committed_ghr  <= next_committed_ghr;
        end
    end

endmodule