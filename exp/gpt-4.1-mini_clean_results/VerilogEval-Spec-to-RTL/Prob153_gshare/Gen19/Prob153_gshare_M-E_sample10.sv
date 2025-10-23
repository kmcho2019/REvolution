module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input   [6:0]  predict_pc,
    output         predict_taken,
    output  [6:0]  predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input   [6:0]  train_history,
    input   [6:0]  train_pc
);

    // PHT: 128 entries of 2-bit saturating counters
    // States: 2'b00 Strongly NT, 2'b01 Weakly NT, 2'b10 Weakly T, 2'b11 Strongly T
    reg [1:0] pht [0:127];
    integer i;

    // Global History Register (GHR) 7 bits
    reg [6:0] ghr;

    // Stage 1: Current prediction index and PHT counter
    wire [6:0] pred_index = predict_pc ^ ghr;
    wire [1:0] pred_counter = pht[pred_index];

    // Predicted taken if MSB of saturating counter is 1
    wire predicted_taken_wire = pred_counter[1];

    // Outputs reflect prediction for current cycle if predict_valid, else zero
    assign predict_taken = predict_valid ? predicted_taken_wire : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Stage 2: Register prediction valid and predicted taken bit (for next cycle GHR update)
    reg         pred_valid_reg;
    reg         pred_taken_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pred_valid_reg <= 1'b0;
            pred_taken_reg <= 1'b0;
        end else begin
            pred_valid_reg <= predict_valid;
            pred_taken_reg <= predicted_taken_wire;
        end
    end

    // Training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;

    // Function: saturating counter update
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

    // Sequential logic: update PHT and GHR at clock edge
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly taken (2'b10)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b10;
            // Clear global history register
            ghr <= 7'b0;
        end else begin
            // Update PHT with training info if train_valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR:
            // Priority 1: if training misprediction, recover ghr to train_history
            // Else if prior cycle had a valid prediction, shift in predicted bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history; // recover history on mispredict flush
            end else if (pred_valid_reg) begin
                ghr <= {ghr[5:0], pred_taken_reg};
            end
            // else hold current ghr
        end
    end

endmodule