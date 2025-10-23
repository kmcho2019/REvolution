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

    // 2-bit saturating counter states
    localparam [1:0] SN = 2'b00; // Strongly Not Taken
    localparam [1:0] WN = 2'b01; // Weakly Not Taken
    localparam [1:0] WT = 2'b10; // Weakly Taken
    localparam [1:0] ST = 2'b11; // Strongly Taken

    // Pattern History Table with 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Current global history register (holds state used for indexing)
    reg [6:0] GHR_current;

    // Next global history register (computed each cycle for update)
    reg [6:0] GHR_next;

    // Registered outputs for stable outputs across cycle
    reg       predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Indices for PHT access
    wire [6:0] predict_index;
    wire [6:0] train_index;

    // Combinational prediction counter read from PHT at index (predict_pc XOR GHR_current)
    wire [1:0] predict_counter;

    assign predict_index = predict_pc ^ GHR_current;
    assign train_index   = train_pc ^ train_history;

    assign predict_counter = PHT[predict_index];

    // Decode prediction (MSB of 2-bit counter)
    wire predict_taken_comb = predict_counter[1];

    // Output assignments (registered)
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_counter_update;
        input [1:0] counter;
        input       taken;
        begin
            case (counter)
                SN: saturate_counter_update = taken ? WN : SN;
                WN: saturate_counter_update = taken ? WT : SN;
                WT: saturate_counter_update = taken ? ST : WN;
                ST: saturate_counter_update = taken ? ST : WT;
                default: saturate_counter_update = WN; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    // Asynchronous reset and sequential logic for registers and PHT update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to Weakly Not Taken
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= WN;
            // Initialize global history registers
            GHR_current <= 7'b0;
            GHR_next <= 7'b0;
            // Clear output registers
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Update PHT entry on training
            if (train_valid) begin
                PHT[train_index] <= saturate_counter_update(PHT[train_index], train_taken);
            end

            // Update GHR_current from GHR_next (committed state update)
            GHR_current <= GHR_next;

            // Latch outputs: prediction valid? latch current prediction state
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_comb;
                predict_history_reg <= GHR_current;
            end else begin
                // Hold previous outputs if no new prediction
                predict_taken_reg <= predict_taken_reg;
                predict_history_reg <= predict_history_reg;
            end

            // Compute next GHR value for next cycle update
            // Priority: train_valid & train_mispredicted => recover GHR to train_history
            // else if predict_valid => shift in predicted bit from latched prediction
            // else hold current GHR

            if (train_valid && train_mispredicted) begin
                GHR_next <= train_history;
            end else if (predict_valid) begin
                // Shift left by 1, append predicted taken bit
                GHR_next <= {GHR_current[5:0], predict_taken_comb};
            end else begin
                GHR_next <= GHR_current;
            end
        end
    end

endmodule