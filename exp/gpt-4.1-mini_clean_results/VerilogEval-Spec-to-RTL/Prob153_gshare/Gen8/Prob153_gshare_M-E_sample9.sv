module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    integer i;

    // Architectural GHR: the committed global history register
    reg [6:0] arch_GHR;
    // Speculative GHR: used for prediction, updated on prediction request
    reg [6:0] spec_GHR;

    // Helper function to update 2-bit saturating counters
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // Weakly not taken
            endcase
        end
    endfunction

    // Compute indices for PHT
    wire [6:0] predict_index = predict_pc ^ spec_GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read prediction counter combinationally (before any updates)
    wire [1:0] predict_counter = PHT[predict_index];
    wire       prediction_bit = predict_counter[1]; // MSB = prediction: 1 taken, 0 not taken

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            arch_GHR <= 7'b0;
            spec_GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Misprediction recovery has highest priority
            if (train_valid && train_mispredicted) begin
                // Restore architectural GHR to train_history (architectural state after mispredicted branch)
                arch_GHR <= train_history;
                // Recover speculative GHR to architectural GHR (discard speculative updates)
                spec_GHR <= train_history;
            end else begin
                // If no misprediction recovery, update arch_GHR on training with actual branch outcome
                if (train_valid) begin
                    arch_GHR <= {arch_GHR[5:0], train_taken};
                    // Do not update spec_GHR here (prediction interface handles speculative updates)
                end

                // Update speculative GHR on prediction if no misprediction recovery this cycle
                if (predict_valid) begin
                    spec_GHR <= {spec_GHR[5:0], prediction_bit};
                end
                // else speculative GHR holds value
            end

            // Register prediction outputs only on predict_valid to hold stable outputs
            if (predict_valid) begin
                predict_taken <= prediction_bit;
                predict_history <= spec_GHR;
            end
            // else outputs remain stable
        end
    end

endmodule