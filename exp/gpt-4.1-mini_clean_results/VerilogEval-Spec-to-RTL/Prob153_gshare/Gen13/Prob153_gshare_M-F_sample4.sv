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

    // Global History Register (state)
    reg [6:0] ghr;

    // Register to hold GHR at prediction request time
    reg [6:0] predict_history_reg;

    // Registers to hold prediction request info for update in next cycle
    reg        predict_valid_reg;
    reg        predict_taken_reg;

    // Function: saturating counter update (2-bit)
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

    // Prediction index computed from predict_pc XOR predict_history_reg (latched GHR)
    wire [6:0] predict_index = predict_pc ^ predict_history_reg;

    // Prediction PHT entry read using predict_index
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs combinational:
    // - predict_taken is MSB of saturating counter entry if valid, else 0
    // - predict_history is the latched GHR at prediction request time if valid, else zero
    assign predict_taken = (predict_valid) ? pht_predict_entry[1] : 1'b0;
    assign predict_history = (predict_valid) ? predict_history_reg : 7'b0;

    // Training index computed from train_pc XOR train_history
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            predict_history_reg <= 7'b0;
            predict_valid_reg <= 1'b0;
            predict_taken_reg <= 1'b0;
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
        end else begin
            // Store GHR at prediction request time to use for output and indexing
            // Update only if predict_valid is high; else keep previous latched value
            if (predict_valid)
                predict_history_reg <= ghr;

            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) recover GHR to train_history if train_valid and train_mispredicted
            // 2) else if previous cycle had a valid prediction, shift in predict_taken_reg
            // 3) else hold GHR
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid_reg) begin
                ghr <= {ghr[5:0], predict_taken_reg};
            end

            // Register previous prediction request info for next cycle updates
            predict_valid_reg <= predict_valid;
            predict_taken_reg <= (predict_valid) ? pht_predict_entry[1] : 1'b0;
        end
    end

endmodule