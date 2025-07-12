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

    // 2-bit saturating counters states:
    // 00 - Strongly Not Taken, 01 - Weakly Not Taken,
    // 10 - Weakly Taken, 11 - Strongly Taken
    localparam WEAK_NOT_TAKEN = 2'b01;

    // Pattern History Table: 128 entries
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entries
    wire [1:0] pht_predict = pht[predict_index];
    wire [1:0] pht_train = pht[train_index];

    // Prediction taken if MSB is 1
    assign predict_taken = pht_predict[1];

    // Output current GHR as predict_history
    assign predict_history = ghr;

    // Saturating increment
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == 2'b11) ? 2'b11 : val + 1'b1;
    endfunction

    // Saturating decrement
    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == 2'b00) ? 2'b00 : val - 1'b1;
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WEAK_NOT_TAKEN;
        end else begin
            // Update PHT entry if training valid
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train);
                else
                    pht[train_index] <= saturate_dec(pht_train);
            end

            // Update GHR with priority:
            // If misprediction training occurs, restore GHR to train_history
            // Else if prediction valid, shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken};
            end
            // else keep GHR unchanged
        end
    end

endmodule