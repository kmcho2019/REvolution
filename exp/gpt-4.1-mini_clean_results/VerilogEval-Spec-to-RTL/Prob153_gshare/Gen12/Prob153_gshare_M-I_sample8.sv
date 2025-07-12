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

    // Registers to hold prediction request info for update in next cycle
    reg        predict_valid_reg;
    reg [6:0]  predict_index_reg;
    reg        predict_taken_reg; // predicted taken from last cycle's prediction request

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

    // Combinational prediction index
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Combinational PHT read for prediction request (before any update)
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs are combinational: based on current GHR and PHT entry
    assign predict_taken = (predict_valid) ? pht_predict_entry[1] : 1'b0; // taken = MSB of counter if valid else 0
    assign predict_history = (predict_valid) ? ghr : 7'b0; // output current GHR if valid else zero

    // Combinational training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            predict_valid_reg <= 1'b0;
            predict_index_reg <= 7'b0;
            predict_taken_reg <= 1'b0;
        end else begin
            // Update pattern history table on training
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority to training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Recover GHR to train_history if mispredicted
                ghr <= train_history;
            end else begin
                // If previous cycle had a valid prediction request, update GHR by shifting in predicted bit
                if (predict_valid_reg) begin
                    ghr <= {ghr[5:0], predict_taken_reg};
                end
                // Else hold GHR unchanged
            end

            // Register prediction request info for next cycle GHR update
            predict_valid_reg <= predict_valid;
            predict_index_reg <= predict_index;
            predict_taken_reg <= (predict_valid) ? pht_predict_entry[1] : 1'b0;
        end
    end

endmodule