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

    // 128-entry 2-bit saturating counters for the PHT
    reg [1:0] PHT [0:127];
    integer i;

    // Architectural Global History Register (arch_GHR)
    reg [6:0] arch_GHR;

    // Speculative Global History Register (spec_GHR)
    reg [6:0] spec_GHR;

    // Index calculation function: XOR PC and GHR
    wire [6:0] predict_index = predict_pc ^ spec_GHR;
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter next state logic
    function [1:0] update_counter;
        input [1:0] ctr;
        input       taken;
        begin
            case (ctr)
                2'b00: update_counter = taken ? 2'b01 : 2'b00;
                2'b01: update_counter = taken ? 2'b10 : 2'b00;
                2'b10: update_counter = taken ? 2'b11 : 2'b01;
                2'b11: update_counter = taken ? 2'b11 : 2'b10;
                default: update_counter = 2'b01;
            endcase
        end
    endfunction

    // Read the PHT entry for prediction combinationally
    wire [1:0] predict_ctr = PHT[predict_index];
    wire       prediction = predict_ctr[1]; // MSB indicates taken/not taken

    // On asynchronous reset initialize PHT entries and GHRs
    // Use generate with synchronous reset for PHT initialization
    // We'll initialize the array inside a generate block (for synthesis compatibility)
    // but since areset is asynchronous, do initialization in always @(*) + reset logic
    // Alternatively, use a reset FSM or a synchronous reset - here we comply with asynchronous reset by using synchronous reset for PHT init on first clock.

    // Synchronous reset for PHT initialization with async reset signal
    reg reset_done;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            reset_done <= 1'b0;
            arch_GHR <= 7'b0;
            spec_GHR <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else if (!reset_done) begin
            // Initialize PHT on first clock after reset release
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01; // weakly not taken
            end
            reset_done <= 1'b1;
        end
    end

    // Main update always block - update PHT and GHRs
    always @(posedge clk) begin
        if (!reset_done) begin
            // Do nothing until PHT is initialized
        end else begin
            // 1. PHT update on training
            if (train_valid) begin
                PHT[train_index] <= update_counter(PHT[train_index], train_taken);
            end

            // 2. GHR update
            if (train_valid && train_mispredicted) begin
                // On misprediction training, recover both GHRs to train_history
                arch_GHR <= train_history;
                spec_GHR <= train_history;
            end else if (predict_valid) begin
                // Speculative update of spec_GHR with predicted bit
                spec_GHR <= {spec_GHR[5:0], prediction};
                // Note: arch_GHR updates only on commit, i.e. on misprediction recovery here
                // Speculative GHR moves forward with predictions
            end
            // else: no changes to GHRs

            // 3. Prediction outputs - register outputs only when predict_valid asserted
            if (predict_valid) begin
                predict_taken <= prediction;
                predict_history <= spec_GHR;
            end
            // else outputs hold their previous stable values
        end
    end

endmodule