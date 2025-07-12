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

    // 2-bit saturating counter states:
    // 2'b00 = strongly not taken
    // 2'b01 = weakly not taken
    // 2'b10 = weakly taken
    // 2'b11 = strongly taken

    // Pattern History Table (PHT) - 128 entries of 2-bit counters
    reg [1:0] PHT [0:127];

    // Global History Register (GHR) - 7 bits
    reg [6:0] ghr;

    // Prediction registers (pipelined outputs)
    reg        predict_taken_r;
    reg [6:0]  predict_history_r;

    // Indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Combinational read of PHT for prediction index
    wire [1:0] pht_predict_counter = PHT[predict_index];

    // Prediction logic: predict taken if MSB of counter is 1 and predict_valid
    wire predict_taken_comb = predict_valid && pht_predict_counter[1];

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    integer i;

    // Sequential logic: PHT update, GHR update, prediction output registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            // Clear GHR
            ghr <= 7'b0;

            // Clear prediction registers
            predict_taken_r <= 1'b0;
            predict_history_r <= 7'b0;
        end else begin
            // Update PHT entry on training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // Priority to training misprediction (recover history)
            // Otherwise update with previous cycle's predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else begin
                // Shift in last cycle's prediction taken bit (pipelined)
                ghr <= {ghr[5:0], predict_taken_r};
            end

            // Pipeline the prediction outputs for stable, cycle-aligned outputs
            predict_taken_r <= predict_taken_comb;
            predict_history_r <= ghr;
        end
    end

    // Assign outputs from pipeline registers
    assign predict_taken = predict_taken_r;
    assign predict_history = predict_history_r;

endmodule