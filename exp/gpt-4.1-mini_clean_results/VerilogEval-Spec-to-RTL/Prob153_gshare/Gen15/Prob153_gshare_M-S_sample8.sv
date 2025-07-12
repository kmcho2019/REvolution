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

    // PHT: 128 entries of 2-bit saturating counters
    // 00 = strongly not taken, 01 = weakly not taken,
    // 10 = weakly taken, 11 = strongly taken
    reg [1:0] pht [0:127];

    // Global history register (7 bits)
    reg [6:0] ghr;

    // Registers to hold latched prediction outputs for stable output signals
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Prediction index and counter read combinationally from current ghr and predict_pc
    wire [6:0] pred_index = predict_pc ^ ghr;
    wire [1:0] pred_counter = pht[pred_index];
    wire       pred_taken = pred_counter[1]; // MSB of counter gives prediction

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
            // Initialize PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;

            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // --- Training update ---
            if (train_valid) begin
                // Update saturating counter at train index
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);

                if (train_mispredicted) begin
                    // Recover global history register on misprediction
                    ghr <= train_history;
                end else begin
                    // Shift in actual train_taken to ghr
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // No training or misprediction recovery; update ghr with predicted taken bit
                ghr <= {ghr[5:0], pred_taken};
            end
            // else: no update to ghr

            // Latch outputs for predict_valid cycle only; otherwise hold previous values
            if (predict_valid) begin
                predict_taken_reg <= pred_taken;
                predict_history_reg <= ghr;
            end else begin
                predict_taken_reg <= predict_taken_reg;
                predict_history_reg <= predict_history_reg;
            end
        end
    end

endmodule