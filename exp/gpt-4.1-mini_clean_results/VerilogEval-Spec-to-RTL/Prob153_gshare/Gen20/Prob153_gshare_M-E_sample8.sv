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

    // Pattern History Table (PHT) with 128 2-bit saturating counters
    // 2'b00 = Strongly Not Taken
    // 2'b01 = Weakly Not Taken
    // 2'b10 = Weakly Taken
    // 2'b11 = Strongly Taken
    reg [1:0] pht [0:127];
    integer i;

    // Global History Register (GHR) 7 bits
    reg [6:0] ghr;

    // Calculate index for prediction and training
    wire [6:0] pred_index  = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT counter for prediction index
    wire [1:0] pred_counter = pht[pred_index];

    // Predict taken if MSB of 2-bit saturating counter is 1
    wire predicted_taken_wire = pred_counter[1];

    // Prediction outputs are combinational and valid only if predict_valid
    assign predict_taken    = predict_valid ? predicted_taken_wire : 1'b0;
    assign predict_history  = predict_valid ? ghr : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter != 2'b11)
                    saturate_update = counter + 1'b1;
                else
                    saturate_update = 2'b11;
            end else begin
                if (counter != 2'b00)
                    saturate_update = counter - 1'b1;
                else
                    saturate_update = 2'b00;
            end
        end
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken state (2'b10)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b10;
            // Reset GHR to zero
            ghr <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) If training misprediction, restore GHR to train_history (flush recovery)
            // 2) Else if previous cycle had a valid prediction, shift in predicted_taken_wire from that cycle
            // 3) Else hold current GHR
            //
            // To implement this, we need to save predicted_taken_wire and predict_valid from previous cycle.

            // Registers to hold previous cycle prediction signals
            // Declare here to make registers visible
        end
    end

    // Registers to hold previous cycle prediction info for GHR update
    reg        pred_valid_prev;
    reg        pred_taken_prev;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_valid_prev <= 1'b0;
            pred_taken_prev <= 1'b0;
        end else begin
            pred_valid_prev <= predict_valid;
            pred_taken_prev <= predicted_taken_wire;
        end
    end

    // Now implement GHR update with priority after all registers are declared
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Already reset above
            ghr <= 7'b0;
        end else begin
            if (train_valid && train_mispredicted) begin
                // Priority: flush recovery of GHR on mispredict training
                ghr <= train_history;
            end else if (pred_valid_prev) begin
                // Shift in predicted taken from previous cycle
                ghr <= {ghr[5:0], pred_taken_prev};
            end else begin
                // Hold current GHR
                ghr <= ghr;
            end
        end
    end

endmodule