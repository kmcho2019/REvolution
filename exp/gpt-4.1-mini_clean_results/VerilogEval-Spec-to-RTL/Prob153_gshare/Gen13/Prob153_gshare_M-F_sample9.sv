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

    // 128-entry PHT: 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Prediction pipeline registers to model synchronous RAM read
    reg        predict_valid_reg;        // latched predict_valid
    reg [6:0]  predict_pc_reg;           // latched predict_pc
    reg [6:0]  predict_history_reg;      // latched GHR at prediction request
    reg [6:0]  predict_index_reg;        // pc ^ history at prediction request

    reg        predict_valid_out;        // indicates valid prediction output stage
    reg [1:0]  predict_counter_reg;      // PHT data read synchronously

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

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction index calculation combinational (for latch)
    wire [6:0] predict_index = predict_pc ^ ghr;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;

            ghr <= 7'b0;

            predict_valid_reg   <= 1'b0;
            predict_pc_reg      <= 7'b0;
            predict_history_reg <= 7'b0;
            predict_index_reg   <= 7'b0;

            predict_valid_out   <= 1'b0;
            predict_counter_reg <= 2'b01; // default weak not taken

            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Training update to PHT (synchronous)
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Prediction stage 1: latch prediction request info
            if (predict_valid) begin
                predict_valid_reg   <= 1'b1;
                predict_pc_reg      <= predict_pc;
                predict_history_reg <= ghr;
                predict_index_reg   <= predict_index;
            end else begin
                predict_valid_reg <= 1'b0;
            end

            // Prediction stage 2: synchronous PHT read at predict_index_reg
            predict_valid_out   <= predict_valid_reg;
            predict_counter_reg <= pht[predict_index_reg];

            // Output prediction results (one cycle after request)
            if (predict_valid_out) begin
                predict_taken   <= predict_counter_reg[1]; // MSB is prediction bit
                predict_history <= predict_history_reg;
            end

            // Update GHR priority:
            // 1) If training mispredict: recover GHR to train_history
            // 2) Else if training valid: shift in train_taken
            // 3) Else if prediction output valid (prediction completes): shift in predicted bit
            // 4) Else hold GHR

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid_out) begin
                ghr <= {ghr[5:0], predict_counter_reg[1]};
            end
            // else retain ghr
        end
    end

endmodule