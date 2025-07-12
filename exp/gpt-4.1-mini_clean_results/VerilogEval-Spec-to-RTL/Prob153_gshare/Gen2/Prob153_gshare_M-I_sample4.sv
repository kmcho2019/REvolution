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

    // Registered predicted_taken to update GHR next cycle
    reg predicted_taken_reg;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT counter for prediction
    wire [1:0] pht_predict_counter = PHT[predict_index];

    // Prediction taken if MSB of PHT counter is 1 and predict_valid is asserted
    wire predict_taken_wire = predict_valid & pht_predict_counter[1];

    assign predict_taken = predict_taken_wire;

    // Output current ghr as prediction history
    assign predict_history = ghr;

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

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            // Clear GHR on reset
            ghr <= 7'b0;
            predicted_taken_reg <= 1'b0;
        end else begin
            // Update PHT entry on training valid by saturating counter
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Latch predicted_taken for use in GHR update next cycle
            if (predict_valid) begin
                predicted_taken_reg <= pht_predict_counter[1];
            end else begin
                predicted_taken_reg <= 1'b0;
            end

            // Update GHR:
            // Priority 1: If training mispredicted, restore GHR to train_history
            // Priority 2: Else if prediction valid (previous cycle), update GHR by shifting in predicted_taken_reg
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predicted_taken_reg};
            end
            // else maintain current GHR
        end
    end

endmodule