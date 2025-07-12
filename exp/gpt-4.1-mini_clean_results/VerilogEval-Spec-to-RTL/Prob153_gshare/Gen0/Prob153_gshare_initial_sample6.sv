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

    // 2-bit saturating counter states
    localparam WEAK_NOT_TAKEN = 2'd1;
    localparam WEAK_TAKEN     = 2'd2;
    localparam STRONG_NOT_TAKEN = 2'd0;
    localparam STRONG_TAKEN     = 2'd3;

    // Pattern History Table: 128 entries of 2-bit counters
    reg [1:0] pht [0:127];

    // Global Branch History Register (7 bits)
    reg [6:0] ghr;

    // Combinational index for prediction: XOR of pc and ghr
    wire [6:0] predict_index = predict_pc ^ ghr;

    // Combinational index for training: XOR of train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries for prediction and training (training PHT read done only for training update)
    wire [1:0] pht_predict = pht[predict_index];
    wire [1:0] pht_train   = pht[train_index];

    // Prediction is 'taken' if MSB of counter is 1 (states 2 or 3)
    assign predict_taken = (pht_predict[1] == 1'b1);

    // Output predict_history is the current global history register
    assign predict_history = ghr;

    // Saturating counter update function for taken branch
    function [1:0] saturating_inc;
        input [1:0] val;
        begin
            if (val == 2'd3)
                saturating_inc = 2'd3;
            else
                saturating_inc = val + 1'b1;
        end
    endfunction

    // Saturating counter update function for not taken branch
    function [1:0] saturating_dec;
        input [1:0] val;
        begin
            if (val == 2'd0)
                saturating_dec = 2'd0;
            else
                saturating_dec = val - 1'b1;
        end
    endfunction

    // Sequential logic for PHT and GHR update
    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // On asynchronous reset, clear GHR and PHT entries
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                // Initialize counters to weak not taken (01)
                pht[i] <= WEAK_NOT_TAKEN;
            end
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                // Update PHT entry at train_index according to train_taken
                if (train_taken)
                    pht[train_index] <= saturating_inc(pht_train);
                else
                    pht[train_index] <= saturating_dec(pht_train);
            end

            // Update GHR and possibly recover GHR on misprediction training
            if (train_valid && train_mispredicted) begin
                // Recover GHR to train_history (state after mispredicted branch)
                ghr <= train_history;
            end else if (predict_valid) begin
                // Update GHR with prediction bit from current cycle's prediction
                // (Only if no mispredicted training in same cycle)
                ghr <= {ghr[5:0], predict_taken};
            end
            // Else keep GHR unchanged
        end
    end

endmodule