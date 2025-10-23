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

    // Global History Registers
    // prediction_ghr is used for prediction outputs (stable during cycle)
    // committed_ghr is updated after training and mispredict recovery
    reg [6:0] prediction_ghr;
    reg [6:0] committed_ghr;

    // Compute indices combinationally
    wire [6:0] predict_index = predict_pc ^ prediction_ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT state for prediction (combinational read port)
    wire [1:0] predict_counter = pht[predict_index];

    // Predict taken if MSB of saturating counter is 1
    wire predicted_taken_bit = predict_counter[1];

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
            // Initialize GHRs and PHT to known states
            prediction_ghr <= 7'b0;
            committed_ghr  <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN; // Weakly Not Taken initial state
            end
        end else begin
            // 1) Update PHT if training valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // 2) Update GHR registers with priority:
            // train_mispredicted recovery > prediction update > no change
            if (train_valid && train_mispredicted) begin
                // On misprediction recovery, restore both GHRs to train_history
                committed_ghr  <= train_history;
                prediction_ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit into prediction_ghr
                prediction_ghr <= {prediction_ghr[5:0], predicted_taken_bit};
                // committed_ghr unchanged this cycle
            end
            // else no change to GHRs
        end
    end

endmodule