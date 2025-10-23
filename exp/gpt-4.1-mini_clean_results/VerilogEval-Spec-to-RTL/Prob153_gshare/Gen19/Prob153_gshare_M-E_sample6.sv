module TopModule(
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

    // 128-entry Pattern History Table (PHT) of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register (committed state, updated on training)
    reg [6:0] ghr;

    // Registers to hold stable outputs
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Speculative predicted bit held for next cycle update of ghr
    reg speculative_predicted_taken;
    reg speculative_valid;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT read ports (asynchronous reads assumed)
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction taken decision (MSB=1 means taken)
    wire predicted_taken = pht_predict_entry[1];

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] curr;
        input       taken;
        begin
            if (taken) begin
                if (curr != 2'b11)
                    saturate_update = curr + 2'b01;
                else
                    saturate_update = curr;
            end else begin
                if (curr != 2'b00)
                    saturate_update = curr - 2'b01;
                else
                    saturate_update = curr;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end

            ghr <= 7'b0;

            // Outputs cleared
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;

            // Clear speculative register
            speculative_predicted_taken <= 1'b0;
            speculative_valid <= 1'b0;
        end else begin
            // Default: no update to outputs unless prediction valid
            if (predict_valid) begin
                // Output prediction based on current ghr
                predict_taken_reg <= predicted_taken;
                predict_history_reg <= ghr;

                // Store speculative predicted bit for next cycle's ghr update
                speculative_predicted_taken <= predicted_taken;
                speculative_valid <= 1'b1;
            end else begin
                // Hold outputs stable
                predict_taken_reg <= predict_taken_reg;
                predict_history_reg <= predict_history_reg;

                // Clear speculative prediction if no new prediction
                speculative_predicted_taken <= 1'b0;
                speculative_valid <= 1'b0;
            end

            // Training updates take priority over speculative history updates
            if (train_valid) begin
                // Update the PHT entry for training index
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On misprediction, recover global history to train_history,
                    // discarding speculative prediction update
                    ghr <= train_history;

                    // Clear speculative prediction since pipeline will flush
                    speculative_valid <= 1'b0;
                end else begin
                    // Commit the actual outcome into global history
                    ghr <= {ghr[5:0], train_taken};
                end
            end else begin
                // No training this cycle, apply speculative update if valid
                if (speculative_valid) begin
                    ghr <= {ghr[5:0], speculative_predicted_taken};
                end
                // else ghr holds steady
            end
        end
    end

    // Output assignments
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule