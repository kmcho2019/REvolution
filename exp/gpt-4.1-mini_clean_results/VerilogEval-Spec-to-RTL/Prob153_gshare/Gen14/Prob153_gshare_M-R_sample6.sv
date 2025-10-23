module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output         predict_taken,
    output [6:0]   predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // 128-entry PHT: 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Prediction pipeline stage 1: latch prediction request info and GHR
    reg        predict_valid_r1;
    reg [6:0]  predict_pc_r1;
    reg [6:0]  predict_ghr_r1;     // GHR at prediction request
    wire [6:0] predict_index_r1;

    assign predict_index_r1 = predict_pc_r1 ^ predict_ghr_r1;

    // Prediction pipeline stage 2: latch PHT output (synchronous RAM read)
    reg        predict_valid_r2;
    reg [6:0]  predict_ghr_r2;
    reg [1:0]  predict_counter_r2; // PHT counter value

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

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

    // Outputs combinationally derived from pipeline stage 2 registers
    assign predict_taken = (predict_valid_r2) ? predict_counter_r2[1] : 1'b0;
    assign predict_history = (predict_valid_r2) ? predict_ghr_r2 : 7'b0;

    // Prediction stage 1 and training updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;

            predict_valid_r1 <= 1'b0;
            predict_pc_r1    <= 7'b0;
            predict_ghr_r1   <= 7'b0;

            predict_valid_r2 <= 1'b0;
            predict_ghr_r2   <= 7'b0;
            predict_counter_r2 <= 2'b01;
        end else begin
            // Training update to PHT (synchronous, next cycle update)
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Prediction stage 1: latch inputs if valid
            if (predict_valid) begin
                predict_valid_r1 <= 1'b1;
                predict_pc_r1    <= predict_pc;
                predict_ghr_r1   <= ghr;
            end else begin
                predict_valid_r1 <= 1'b0;
            end

            // Prediction stage 2: latch PHT output synchronously
            predict_valid_r2 <= predict_valid_r1;
            predict_ghr_r2   <= predict_ghr_r1;
            predict_counter_r2 <= (predict_valid_r1) ? pht[predict_index_r1] : 2'b01;

            // Update GHR with priority:
            // 1) If training misprediction: recover GHR to train_history
            // 2) Else if training valid: shift in train_taken
            // 3) Else if prediction valid stage 2: shift in predicted bit
            // 4) Else hold GHR

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_r2) begin
                ghr <= {ghr[5:0], predict_counter_r2[1]};
            end
            // else ghr unchanged
        end
    end

endmodule