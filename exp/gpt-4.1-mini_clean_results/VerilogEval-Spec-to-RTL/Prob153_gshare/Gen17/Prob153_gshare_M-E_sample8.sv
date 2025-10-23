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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Two Global History Registers:
    // ghr_spec: speculative history (includes predictions)
    // ghr_comm: committed history (only confirmed branches)
    reg [6:0] ghr_spec;
    reg [6:0] ghr_comm;

    // Combinational index and prediction signals for predict
    wire [6:0] pred_index = predict_pc ^ ghr_spec;
    wire [1:0] pred_counter = pht[pred_index];
    wire       pred_taken = pred_counter[1]; // MSB is prediction bit

    // Assign prediction outputs combinationally to reflect pre-update state
    assign predict_taken = (predict_valid) ? pred_taken : 1'b0;
    assign predict_history = (predict_valid) ? ghr_spec : 7'b0;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr_spec <= 7'd0;
            ghr_comm <= 7'd0;
        end else begin
            // Update PHT on training cycles only
            if (train_valid) begin
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);
            end

            // Update histories with clear priority
            if (train_valid && train_mispredicted) begin
                // Recover speculative history to correct committed history after misprediction
                ghr_spec <= train_history;
                // Committed history stays unchanged (reflects confirmed past)
                // ghr_comm not updated here since train_taken is wrong outcome
            end else if (train_valid) begin
                // Commit new history with actual outcome
                ghr_comm <= {ghr_comm[5:0], train_taken};
                // Speculative history also updated to reflect commit state
                ghr_spec <= {ghr_comm[5:0], train_taken};
            end else if (predict_valid) begin
                // Speculative update with predicted outcome
                ghr_spec <= {ghr_spec[5:0], pred_taken};
                // Committed history unchanged (waiting for training)
            end
            // Else no updates; histories hold
        end
    end

endmodule