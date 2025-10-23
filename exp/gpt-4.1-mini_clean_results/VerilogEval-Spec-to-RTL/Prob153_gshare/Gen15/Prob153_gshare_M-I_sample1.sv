module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg        predict_taken,
    output reg [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Committed GHR (reflects confirmed outcomes after training)
    reg [6:0] commit_ghr;

    // Speculative GHR (reflects predictions in fetch)
    reg [6:0] spec_ghr;

    // Indices for PHT access
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    wire [6:0] train_index   = train_pc   ^ train_history;

    // Read current prediction counter for prediction index
    wire [1:0] predict_counter = PHT[predict_index];

    // Saturating counter update helper function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    saturate_update = counter + 1;
                else
                    saturate_update = 2'b11;
            end else begin
                if (counter != 2'b00)
                    saturate_update = counter - 1;
                else
                    saturate_update = 2'b00;
            end
        end
    endfunction

    integer i;

    // -------------------------------------------
    // 1) Update outputs (predict_taken, predict_history) registered on predict_valid
    //    but only if there is no simultaneous train misprediction (priority)
    // -------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // If misprediction training in same cycle, discard prediction outputs (because prediction is discarded)
            if (train_valid && train_mispredicted) begin
                predict_taken   <= 1'b0;
                predict_history <= 7'b0;
            end else if (predict_valid) begin
                predict_taken   <= predict_counter[1];
                predict_history <= spec_ghr;
            end
        end
    end

    // -------------------------------------------
    // 2) Update PHT entries and committed GHR on training
    // -------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            commit_ghr <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT saturating counter at train index
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update committed GHR
            if (train_valid && train_mispredicted) begin
                // Recover committed GHR on misprediction
                commit_ghr <= train_history;
            end else if (train_valid) begin
                // Shift in actual branch outcome at training time
                commit_ghr <= {commit_ghr[5:0], train_taken};
            end
        end
    end

    // -------------------------------------------
    // 3) Update speculative GHR on prediction or misprediction recovery
    //    Priority:
    //       If train_valid & train_mispredicted -> spec_ghr = train_history (recovery)
    //       Else if predict_valid               -> spec_ghr = {spec_ghr[5:0], predicted_bit}
    //       Else                              -> no change
    // -------------------------------------------
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            spec_ghr <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                // Recovery from mispredict: reset speculative GHR
                spec_ghr <= train_history;
            end else if (predict_valid) begin
                // Append predicted bit to speculative GHR
                spec_ghr <= {spec_ghr[5:0], predict_counter[1]};
            end
            // Else keep spec_ghr unchanged
        end
    end

endmodule