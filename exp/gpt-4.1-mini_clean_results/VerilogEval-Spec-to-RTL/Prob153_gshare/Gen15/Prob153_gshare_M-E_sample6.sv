module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output         predict_taken,
    output [6:0]   predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht_mem [0:127];

    // Global History Register (7 bits)
    reg [6:0] ghr;

    integer i;

    // Compute prediction index: PC XOR GHR
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Compute training index: train_pc XOR train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current counter for prediction index
    wire [1:0] pht_counter = pht_mem[predict_index];

    // Prediction output logic:
    // Taken if MSB of counter is 1 (states 10 or 11)
    assign predict_taken = predict_valid ? pht_counter[1] : 1'b0;

    // Output the GHR used for prediction (before update)
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1;
            end else begin
                saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1;
            end
        end
    endfunction

    // Sequential logic: reset, update PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht_mem[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Training update to PHT takes priority over prediction
            if (train_valid) begin
                // Update PHT entry at train_index
                pht_mem[train_index] <= saturate_update(pht_mem[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training with misprediction, recover GHR to train_history
            // 2) Else if training valid (not mispredicted), update GHR with actual train_taken
            // 3) Else if prediction valid, update GHR with predicted bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_counter[1]};
            end else begin
                // Hold current GHR
                ghr <= ghr;
            end
        end
    end

endmodule