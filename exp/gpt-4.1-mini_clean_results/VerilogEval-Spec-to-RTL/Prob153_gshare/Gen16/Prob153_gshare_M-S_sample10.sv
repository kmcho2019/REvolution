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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Register to hold GHR used for last prediction output
    reg [6:0] predict_history_reg;

    // Compute prediction index from (predict_pc XOR current GHR)
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Current PHT entry for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Output prediction: taken if MSB of saturating counter is 1 and predict_valid asserted
    assign predict_taken = predict_valid && pht_predict_entry[1];
    assign predict_history = predict_history_reg;

    // Function: saturating counter update
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
    endfunction

    // Compute training index from train_pc XOR train_history
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // On prediction request, latch the current GHR for output
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT on training (non-blocking ensures old state read is used for prediction)
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training valid & mispredicted: recover GHR to train_history
            // 2) Else if prediction valid & no concurrent mispredicted training: shift in predicted bit
            // 3) Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
        end
    end

endmodule