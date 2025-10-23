module TopModule(
    input             clk,
    input             areset,

    // Prediction interface
    input             predict_valid,
    input      [6:0]  predict_pc,
    output            predict_taken,
    output     [6:0]  predict_history,

    // Training interface
    input             train_valid,
    input             train_taken,
    input             train_mispredicted,
    input      [6:0]  train_history,
    input      [6:0]  train_pc
);

    // 2-bit saturating counters state encoding:
    // 2'b00 = strongly not taken
    // 2'b01 = weakly not taken
    // 2'b10 = weakly taken
    // 2'b11 = strongly taken

    // Pattern History Table (PHT) - 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Register (GHR) - 7 bits
    reg [6:0] ghr;

    // Prediction latches: latch GHR and PC at predict_valid to fix stable prediction inputs
    reg [6:0] pred_ghr;
    reg [6:0] pred_pc;
    reg       pred_valid_r;

    // On predict_valid, latch predict_pc and current ghr for stable prediction inputs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_ghr    <= 7'b0;
            pred_pc     <= 7'b0;
            pred_valid_r <= 1'b0;
        end else begin
            if (predict_valid) begin
                pred_ghr    <= ghr;
                pred_pc     <= predict_pc;
                pred_valid_r <= 1'b1;
            end else begin
                pred_valid_r <= 1'b0; // clear if no prediction this cycle
            end
        end
    end

    // Compute prediction index from latched values
    wire [6:0] pred_index = pred_pc ^ pred_ghr;

    // Read PHT entry at prediction index (combinational read)
    wire [1:0] pht_pred_counter = PHT[pred_index];

    // Prediction taken: MSB of PHT counter if prediction valid
    wire pred_taken = pred_valid_r & pht_pred_counter[1];

    assign predict_taken = pred_taken;
    assign predict_history = pred_ghr;

    // Function: saturating update of 2-bit counter given taken outcome
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    // Compute training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            // Clear GHR on reset
            ghr <= 7'b0;
        end else begin
            // Update PHT entry on training valid by saturating counter
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // Priority 1: If training mispredicted, recover GHR to train_history
            // Priority 2: Else if prediction valid, shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit from current cycle's prediction outputs (from latched GHR/PHT)
                ghr <= {ghr[5:0], predict_taken};
            end
            // else keep current GHR
        end
    end

endmodule