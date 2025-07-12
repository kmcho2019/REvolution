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

    // Saturating counter states
    localparam WEAK_NOT_TAKEN = 2'b01;

    // Pattern History Table (PHT)
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Function for saturating increment
    function [1:0] saturate_inc;
        input [1:0] val;
        begin
            saturate_inc = (val == 2'b11) ? 2'b11 : val + 2'b01;
        end
    endfunction

    // Function for saturating decrement
    function [1:0] saturate_dec;
        input [1:0] val;
        begin
            saturate_dec = (val == 2'b00) ? 2'b00 : val - 2'b01;
        end
    endfunction

    integer i;

    // Combinational logic for prediction index and prediction bit
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire       predict_taken_comb = pht_predict_entry[1]; // MSB is prediction bit

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Registers for outputs
    reg        predict_taken_r;
    reg [6:0]  predict_history_r;

    // Sequential block for updates and output registering
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WEAK_NOT_TAKEN;
            end
            predict_taken_r <= 1'b0;
            predict_history_r <= 7'b0;
        end else begin
            // Register prediction outputs when predict_valid asserted
            // Capture GHR and prediction bit before any updates
            if (predict_valid) begin
                predict_taken_r <= predict_taken_comb;
                predict_history_r <= ghr;
            end else begin
                // When no prediction, outputs hold last valid value or could be cleared
                // Here choose to hold last valid outputs (stable)
                // Alternatively, could reset outputs to zero here if desired
            end

            // Update PHT on training request
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR with priority:
            // 1. If training with misprediction, restore GHR to train_history
            // 2. Else if prediction valid, update GHR with predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken_comb};
            end
            // Else ghr holds its value
        end
    end

    assign predict_taken = predict_taken_r;
    assign predict_history = predict_history_r;

endmodule