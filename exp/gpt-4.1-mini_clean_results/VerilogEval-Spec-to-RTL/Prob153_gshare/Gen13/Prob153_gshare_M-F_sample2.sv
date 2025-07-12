module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output reg     predict_taken,
    output reg [6:0] predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // PHT: 128 x 2-bit saturating counters, synchronous memory modeled with registers
    reg [1:0] pht [0:127];

    // Predictor pipeline registers:
    // Stage 1 registers: latch prediction inputs
    reg        predict_valid_s1;
    reg [6:0]  predict_pc_s1;
    reg [6:0]  predict_ghr_s1;

    // Stage 2 registers: latch prediction index and valid
    reg        predict_valid_s2;
    reg [6:0]  predict_index_s2;
    reg [1:0]  predict_counter_s2;
    reg [6:0]  predict_ghr_s2;

    // Global History Register
    reg [6:0] ghr;

    // Indexes for training
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Function to saturate counter update
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

    // Stage 1 index calculation: done combinationally for stage 2 address register
    wire [6:0] predict_index_s1 = predict_pc_s1 ^ predict_ghr_s1;

    // Synchronous PHT read emulation:
    // Stage 2 captures PHT data at the address latched at stage 1 in previous cycle

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;

            predict_valid_s1 <= 1'b0;
            predict_pc_s1 <= 7'b0;
            predict_ghr_s1 <= 7'b0;

            predict_valid_s2 <= 1'b0;
            predict_index_s2 <= 7'b0;
            predict_counter_s2 <= 2'b01;
            predict_ghr_s2 <= 7'b0;

            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // -------------------
            // Training logic: synchronous PHT update
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // -------------------
            // Predictor pipeline stage 1: latch prediction inputs if valid
            if (predict_valid) begin
                predict_valid_s1 <= 1'b1;
                predict_pc_s1 <= predict_pc;
                predict_ghr_s1 <= ghr;
            end else begin
                predict_valid_s1 <= 1'b0;
            end

            // -------------------
            // Predictor pipeline stage 2: latch index and PHT data for previous cycle's stage 1 address
            predict_valid_s2 <= predict_valid_s1;
            predict_index_s2 <= predict_index_s1;
            predict_ghr_s2 <= predict_ghr_s1;
            predict_counter_s2 <= pht[predict_index_s1];

            // -------------------
            // Update outputs only when stage 2 valid
            if (predict_valid_s2) begin
                predict_taken <= predict_counter_s2[1]; // MSB is prediction bit
                predict_history <= predict_ghr_s2;
            end

            // -------------------
            // Update global history register with priority:
            // 1. If training valid and mispredicted: recover GHR to train_history
            // 2. Else if training valid: shift in train_taken
            // 3. Else if prediction valid stage 2: shift in predicted taken bit
            // 4. Else hold GHR

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_s2) begin
                ghr <= {ghr[5:0], predict_counter_s2[1]};
            end else begin
                ghr <= ghr;
            end
        end
    end

endmodule