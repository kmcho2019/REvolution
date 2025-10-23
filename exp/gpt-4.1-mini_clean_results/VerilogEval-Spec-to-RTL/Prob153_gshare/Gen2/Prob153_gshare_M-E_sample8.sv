module TopModule (
    input        clk,
    input        areset,

    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // 2-bit saturating counter states:
    // 00 Strongly Not Taken
    // 01 Weakly Not Taken
    // 10 Weakly Taken
    // 11 Strongly Taken
    localparam WEAK_NOT_TAKEN = 2'b01;

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Pipeline registers to hold prediction outputs
    reg        pred_taken_r;
    reg [6:0]  pred_history_r;

    // Combinational index for prediction: XOR of predict_pc and current GHR
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Combinational read of PHT entry for prediction index
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction output is MSB of saturating counter
    wire predict_taken_comb = pht_predict_entry[1];

    // Combinational index for training: XOR of train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating increment function
    function [1:0] saturate_inc;
        input [1:0] val;
        begin
            saturate_inc = (val == 2'b11) ? 2'b11 : val + 2'b01;
        end
    endfunction

    // Saturating decrement function
    function [1:0] saturate_dec;
        input [1:0] val;
        begin
            saturate_dec = (val == 2'b00) ? 2'b00 : val - 2'b01;
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            pred_taken_r <= 1'b0;
            pred_history_r <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WEAK_NOT_TAKEN;
        end else begin
            // Update PHT on training
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR:
            // Priority:
            // 1) If training misprediction, restore GHR to train_history
            // 2) else if prediction valid, shift in predicted bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pred_taken_r};
            end

            // Update prediction pipeline registers with current cycle prediction inputs
            if (predict_valid) begin
                pred_taken_r <= predict_taken_comb;
                pred_history_r <= ghr;
            end else begin
                // If no prediction, hold previous values
                pred_taken_r <= pred_taken_r;
                pred_history_r <= pred_history_r;
            end
        end
    end

    // Output registered prediction values
    assign predict_taken = pred_taken_r;
    assign predict_history = pred_history_r;

endmodule