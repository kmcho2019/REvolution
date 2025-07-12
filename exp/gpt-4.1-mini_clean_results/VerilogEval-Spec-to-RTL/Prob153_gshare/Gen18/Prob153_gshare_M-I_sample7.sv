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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR) - holds 7-bit global history
    reg [6:0] ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = state + 1'b1;
            end else begin
                if (state == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = state - 1'b1;
            end
        end
    endfunction

    // Compute indexes
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read counters combinationally (before any update)
    wire [1:0] predict_counter = pht[predict_index];
    wire [1:0] train_counter   = pht[train_index];

    // Prediction: MSB of saturating counter is the prediction bit
    wire predicted_taken = predict_counter[1];

    // Outputs: combinationally driven based on current stable ghr and pht state
    assign predict_taken    = predict_valid ? predicted_taken : 1'b0;
    assign predict_history  = ghr;

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            // Reset global history to zero
            ghr <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(train_counter, train_taken);
            end

            // Update GHR with priority:
            // 1) On misprediction recovery (training), restore ghr to train_history
            // 2) Else, if prediction valid, update ghr by shifting in predicted_taken bit
            // 3) Else, hold ghr
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predicted_taken};
            end
            // else ghr unchanged
        end
    end

endmodule