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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    integer i;

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Registers to hold the outputs when predict_valid is low
    reg        predict_taken_reg;
    reg  [6:0] predict_history_reg;

    // Combinational prediction index and counter
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction bit

    // Combinational training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                if (counter == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = counter + 1;
            end else begin
                if (counter == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = counter - 1;
            end
        end
    endfunction

    // Output assignments:
    // When predict_valid is asserted, outputs reflect current prediction and GHR;
    // otherwise, hold the registered output values.
    assign predict_taken  = predict_valid ? predict_bit : predict_taken_reg;
    assign predict_history = predict_valid ? ghr : predict_history_reg;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Update output registers to hold stable outputs when predict_valid is low
            if (predict_valid) begin
                predict_taken_reg <= predict_bit;
                predict_history_reg <= ghr;
            end
            // else hold previous values

            // Update PHT on training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) Training mispredicted (recover GHR)
            // 2) Training (update with actual taken)
            // 3) Prediction (update with predicted bit)
            // 4) Otherwise hold GHR

            if (train_valid && train_mispredicted) begin
                // Recover GHR after mispredicted branch execution completes
                ghr <= train_history;
            end else if (train_valid) begin
                // Shift in actual branch outcome during training
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predicted branch outcome during prediction
                ghr <= {ghr[5:0], predict_bit};
            end
            // else hold GHR unchanged
        end
    end

endmodule