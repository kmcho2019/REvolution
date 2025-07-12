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

    // Global History Register (7 bits) - speculative global history
    reg [6:0] ghr;

    // Pipeline registers to hold last prediction info for updating GHR speculatively
    reg        last_predict_valid;
    reg        last_predict_taken;

    // Function: saturating counter next state update
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
    endfunction

    // Combinational prediction index and PHT read for current inputs and ghr
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Combinational prediction outputs:
    // - predict_taken is MSB of 2-bit counter: 1 => taken, 0 => not taken
    // - predict_history is current ghr (history used for prediction)
    assign predict_taken   = predict_valid ? pht_predict_entry[1] : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Training index and PHT entry read (used only for update)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;

            last_predict_valid <= 1'b0;
            last_predict_taken <= 1'b0;
        end else begin
            // Update PHT entry if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end

            // Update GHR with priority:
            // 1) If training with mispredict, recover GHR to train_history
            // 2) Else if previous cycle had valid prediction, update GHR speculatively with predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (last_predict_valid) begin
                ghr <= {ghr[5:0], last_predict_taken};
            end
            // else ghr remains unchanged

            // Save current cycle's prediction info to update GHR next cycle
            last_predict_valid <= predict_valid;
            last_predict_taken <= (predict_valid ? pht_predict_entry[1] : 1'b0);
        end
    end

endmodule