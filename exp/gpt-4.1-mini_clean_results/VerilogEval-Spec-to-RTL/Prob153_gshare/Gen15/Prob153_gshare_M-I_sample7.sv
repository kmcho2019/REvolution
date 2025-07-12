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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    integer i;

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Registers to hold stable outputs when predict_valid is low
    reg        predict_taken_reg;
    reg  [6:0] predict_history_reg;

    // Combinational prediction index and counter read
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB of saturating counter is prediction bit

    // Combinational training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1;
            end else begin
                saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1;
            end
        end
    endfunction

    // Outputs: combinational when predict_valid, else hold registered stable values
    assign predict_taken   = predict_valid ? predict_bit : predict_taken_reg;
    assign predict_history = predict_valid ? ghr : predict_history_reg;

    // Initialize PHT to weakly not taken (2'b01)
    initial begin
        for (i = 0; i < 128; i = i + 1) begin
            PHT[i] = 2'b01;
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Async reset: clear GHR and output registers
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
            // PHT initialization done in initial block for synthesis tools
        end else begin
            // Hold stable outputs when no prediction
            if (predict_valid) begin
                predict_taken_reg <= predict_bit;
                predict_history_reg <= ghr;
            end

            // Update PHT at clock edge on training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // Update GHR with priority:
            // 1) Training misprediction recovery (override GHR)
            // 2) Training update (shift in actual branch outcome)
            // 3) Prediction update (shift in predicted outcome)
            if (train_valid && train_mispredicted) begin
                // Recover GHR on misprediction
                ghr <= train_history;
            end else if (train_valid) begin
                // Shift in actual branch outcome from training
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Shift in predicted bit during prediction
                ghr <= {ghr[5:0], predict_bit};
            end
            // else hold GHR unchanged
        end
    end

endmodule