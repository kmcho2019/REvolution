module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Committed Global History Register (GHR)
    reg [6:0] commit_ghr;

    // Speculative GHR used for prediction
    reg [6:0] spec_ghr;

    // Index wires
    wire [6:0] predict_index = predict_pc ^ spec_ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT counters
    wire [1:0] predict_counter = PHT[predict_index];

    // Prediction output: MSB indicates taken or not
    assign predict_taken = (predict_valid) ? predict_counter[1] : 1'b0;

    // predict_history output: combinationally assigned to spec_ghr if predict_valid, else zero
    assign predict_history = (predict_valid) ? spec_ghr : 7'b0;

    // Helper function for 2-bit saturating counter update
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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            commit_ghr <= 7'b0;
            spec_ghr <= 7'b0;
        end else begin
            // Training PHT update (lowest priority)
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Committed GHR update with priority:
            // 1) If misprediction -> recover to train_history
            // 2) Else if training valid -> shift in train_taken
            // 3) Else no change
            if (train_valid && train_mispredicted) begin
                commit_ghr <= train_history;
            end else if (train_valid) begin
                commit_ghr <= {commit_ghr[5:0], train_taken};
            end

            // Speculative GHR update:
            // Priority to training mispredict recovery
            // Else if prediction valid, update spec_ghr with predicted taken bit
            // Else keep spec_ghr unchanged
            if (train_valid && train_mispredicted) begin
                // Recover speculative GHR to committed GHR after mispredict
                spec_ghr <= train_history;
            end else if (predict_valid) begin
                // Append predicted taken bit to speculative GHR
                spec_ghr <= {spec_ghr[5:0], predict_counter[1]};
            end
            // Else no change to spec_ghr
        end
    end

endmodule