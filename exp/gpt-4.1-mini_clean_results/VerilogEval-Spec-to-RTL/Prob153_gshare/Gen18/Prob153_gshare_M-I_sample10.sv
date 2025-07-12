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

    // Combinational indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT read data registered to avoid async read timing issues
    reg [1:0] pht_pred_entry_reg;

    // Next state of PHT entry for training update
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

    integer i;

    // Pipeline registers for prediction outputs
    reg        pred_taken_reg;
    reg [6:0]  pred_history_reg;

    // Internal register to hold PHT read for prediction index
    wire [1:0] pht_pred_entry_next;

    // We do a synchronous read: on clock, register PHT[predict_index] to pht_pred_entry_reg
    // To achieve this, pht_pred_entry_reg must latch PHT[predict_index] at clock edge,
    // so prediction output is one cycle delayed but stable and fully synchronous.

    // Reading PHT asynchronously is discouraged, so latch input index and pht output.

    reg [6:0] predict_index_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_index_reg <= 7'd0;
            pht_pred_entry_reg <= 2'b01; // weakly not taken default
        end else begin
            predict_index_reg <= predict_index;
            pht_pred_entry_reg <= pht[predict_index];
        end
    end

    // Produce prediction outputs one cycle after predict_valid is asserted:
    // So pipeline predict_valid to align with pht_pred_entry_reg and predict_index_reg

    reg predict_valid_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_valid_reg <= 1'b0;
            pred_taken_reg <= 1'b0;
            pred_history_reg <= 7'd0;
        end else begin
            predict_valid_reg <= predict_valid;
            if (predict_valid) begin
                // Use registered PHT entry read last cycle
                // But spec states prediction outputs correspond to PHT and GHR used for prediction.
                // Here, pht_pred_entry_reg was registered at last clock edge, after predict_index was registered.
                // This gives 1 cycle latency; aligns with stable pipeline.
                // pred_history_reg holds GHR at cycle when prediction was requested,
                // so we latch GHR at predict_valid to hold the history used for prediction.

                pred_taken_reg <= pht_pred_entry_reg[1]; // MSB indicates taken
                pred_history_reg <= ghr; // History before update
            end
        end
    end

    // Assign outputs
    assign predict_taken = pred_taken_reg;
    assign predict_history = pred_history_reg;

    // Update PHT and GHR on clock edge, priority handling:

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'd0;
        end else begin
            // Update PHT table on training (if valid)
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training valid and mispredicted: recover GHR from train_history
            // 2) Else if prediction valid (previous cycle's valid) and no concurrent mispredicted training: shift in predicted bit from PHT entry used in prediction
            // Note: Use predict_valid_reg as prediction was registered last cycle.

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid_reg && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pred_taken_reg};
            end
            // else keep GHR unchanged
        end
    end

endmodule