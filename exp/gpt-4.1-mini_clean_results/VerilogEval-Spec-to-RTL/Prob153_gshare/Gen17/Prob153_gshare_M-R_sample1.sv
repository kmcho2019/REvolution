module TopModule(
    input          clk,
    input          areset,

    // Prediction interface
    input          predict_valid,
    input  [6:0]   predict_pc,
    output         predict_taken,
    output [6:0]   predict_history,

    // Training interface
    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Registers holding last cycle's prediction info to update GHR at clock edge
    reg        predict_valid_d;
    reg [6:0]  predict_pc_d;
    reg [6:0]  predict_ghr_d;
    reg        predict_taken_d;

    // Compute index for current prediction (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] pht_entry_predict = pht[predict_index];

    // Current prediction outputs (combinational)
    assign predict_taken   = predict_valid ? pht_entry_predict[1] : 1'b0;
    assign predict_history = ghr;

    // Compute index for training update (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_entry_train = pht[train_index];

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end

            ghr <= 7'b0;

            predict_valid_d <= 1'b0;
            predict_pc_d <= 7'b0;
            predict_ghr_d <= 7'b0;
            predict_taken_d <= 1'b0;
        end else begin
            // Save current prediction info to update GHR next cycle
            predict_valid_d <= predict_valid;
            predict_pc_d <= predict_pc;
            predict_ghr_d <= ghr;
            predict_taken_d <= pht_entry_predict[1];

            // Update PHT entry on training request
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_entry_train, train_taken);
            end

            // Update GHR with priority:
            // 1) Training misprediction recovery
            // 2) Else if previous cycle prediction valid, speculatively update GHR
            if (train_valid && train_mispredicted) begin
                // Recover GHR after mispredicted branch completes execution
                ghr <= train_history;
            end else if (predict_valid_d) begin
                ghr <= {predict_ghr_d[5:0], predict_taken_d};
            end
            // Else hold GHR steady
        end
    end

endmodule