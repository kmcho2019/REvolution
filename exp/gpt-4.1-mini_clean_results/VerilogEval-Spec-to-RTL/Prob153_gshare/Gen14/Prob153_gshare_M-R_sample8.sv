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

    // PHT: 128 entries of 2-bit saturating counters
    reg [1:0] pht_mem [0:127];

    // --- Registers modeling synchronous RAM read ---
    reg [6:0] pht_raddr;      // Read address registered on clk (predict stage 2)
    reg [1:0] pht_rdata;      // Data output registered from PHT (stage 3)

    integer i;

    // Global History Register
    reg [6:0] ghr;

    // --- Prediction Pipeline Registers ---
    // Stage 1: latch predict inputs and GHR
    reg        predict_valid_s1;
    reg [6:0]  predict_pc_s1;
    reg [6:0]  predict_ghr_s1;

    // Stage 2: compute index and latch
    reg        predict_valid_s2;
    reg [6:0]  predict_index_s2;
    reg [6:0]  predict_ghr_s2;

    // Stage 3: latch PHT output and history
    reg        predict_valid_s3;
    reg [1:0]  predict_counter_s3;
    reg [6:0]  predict_ghr_s3;

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

    // --- Combinational wires for train index ---
    wire [6:0] train_index = train_pc ^ train_history;

    // --- Assign outputs from stage 3 pipeline registers ---
    assign predict_taken = (predict_valid_s3) ? predict_counter_s3[1] : 1'b0;
    assign predict_history = (predict_valid_s3) ? predict_ghr_s3 : 7'b0;

    // --- Sequential logic ---
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht_mem[i] <= 2'b01;
            end

            // Reset GHR
            ghr <= 7'b0;

            // Clear pipeline registers
            predict_valid_s1 <= 1'b0;
            predict_pc_s1 <= 7'b0;
            predict_ghr_s1 <= 7'b0;

            predict_valid_s2 <= 1'b0;
            predict_index_s2 <= 7'b0;
            predict_ghr_s2 <= 7'b0;

            predict_valid_s3 <= 1'b0;
            predict_counter_s3 <= 2'b01;
            predict_ghr_s3 <= 7'b0;

            pht_raddr <= 7'b0;
            pht_rdata <= 2'b01;
        end else begin
            // --- Training write ---
            if (train_valid) begin
                // Write updated counter to PHT synchronously (write-first RAM semantics)
                pht_mem[train_index] <= saturate_update(pht_mem[train_index], train_taken);
            end

            // --- Prediction pipeline stage 1 ---
            predict_valid_s1 <= predict_valid;
            predict_pc_s1 <= predict_pc;
            predict_ghr_s1 <= ghr;

            // --- Prediction pipeline stage 2 ---
            predict_valid_s2 <= predict_valid_s1;
            predict_index_s2 <= predict_pc_s1 ^ predict_ghr_s1;
            predict_ghr_s2 <= predict_ghr_s1;

            // --- Register read address for PHT synchronous read ---
            pht_raddr <= predict_index_s2;

            // --- Prediction pipeline stage 3 ---
            predict_valid_s3 <= predict_valid_s2;
            predict_ghr_s3 <= predict_ghr_s2;

            // --- Register PHT data output for read address from previous cycle ---
            pht_rdata <= pht_mem[pht_raddr];
            predict_counter_s3 <= pht_rdata;

            // --- GHR update with priority ---
            if (train_valid && train_mispredicted) begin
                // Recover GHR to branch history after misprediction
                ghr <= train_history;
            end else if (train_valid) begin
                // Update GHR with actual branch outcome from training
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_s3) begin
                // Update GHR with prediction outcome from PHT stage 3 data
                ghr <= {ghr[5:0], predict_counter_s3[1]};
            end else begin
                // Hold GHR
                ghr <= ghr;
            end
        end
    end

endmodule