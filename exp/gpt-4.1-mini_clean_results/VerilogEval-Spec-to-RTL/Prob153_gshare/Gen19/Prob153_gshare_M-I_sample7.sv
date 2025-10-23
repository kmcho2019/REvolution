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

    // Global history registers:
    // fetch_ghr - used for prediction indexing and updated by prediction
    // train_ghr - used to track history updated by training and flushed on misprediction
    reg [6:0] fetch_ghr;
    reg [6:0] train_ghr;

    // Prediction combinational index and read
    wire [6:0] predict_index = predict_pc ^ fetch_ghr;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predict_taken_wire = predict_counter[1];

    // Training combinational index
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction outputs registers
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            fetch_ghr <= 7'b0;
            train_ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch prediction outputs if valid
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= fetch_ghr;
            end

            // Compute next train_ghr value depending on training inputs
            // Use a temporary reg to hold next train_ghr for sequencing
            reg [6:0] next_train_ghr;
            next_train_ghr = train_ghr; // default hold

            if (train_valid) begin
                if (train_mispredicted) begin
                    // Recover train_ghr to flush history immediately
                    next_train_ghr = train_history;
                end else begin
                    // Shift in actual branch outcome into train_ghr
                    next_train_ghr = {train_ghr[5:0], train_taken};
                end

                // Update saturating counter at train_index based on actual branch outcome
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update train_ghr with computed value
            train_ghr <= next_train_ghr;

            // Update fetch_ghr:
            // On misprediction flush (training valid + mispredicted), recover fetch_ghr from train_ghr (the updated one)
            // else if prediction valid, shift in predicted taken
            // else hold
            if (train_valid && train_mispredicted) begin
                // On flush, fetch_ghr recovers to new train_ghr after flush update
                fetch_ghr <= next_train_ghr;
            end else if (predict_valid) begin
                fetch_ghr <= {fetch_ghr[5:0], predict_taken_wire};
            end
            // else hold fetch_ghr unchanged
        end
    end

endmodule