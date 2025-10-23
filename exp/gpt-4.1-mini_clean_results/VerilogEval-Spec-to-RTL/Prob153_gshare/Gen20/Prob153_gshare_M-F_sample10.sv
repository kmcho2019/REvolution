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

    // 128-entry Pattern History Table (PHT) of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register (committed state)
    reg [6:0] ghr;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries asynchronously
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction decision based on MSB of counter
    wire predicted_taken = pht_predict_entry[1];

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] curr;
        input       taken;
        begin
            if (taken) begin
                if (curr != 2'b11)
                    saturate_update = curr + 2'b01;
                else
                    saturate_update = curr;
            end else begin
                if (curr != 2'b00)
                    saturate_update = curr - 2'b01;
                else
                    saturate_update = curr;
            end
        end
    endfunction

    integer i;

    // Predict outputs are combinational and based on current state *before* any clock-edge update
    assign predict_taken = predict_valid ? predicted_taken : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT entry for training index based on actual outcome
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);

                if (train_mispredicted) begin
                    // On mispredict, recover ghr to train_history (history *after* mispredicted branch)
                    ghr <= train_history;
                end else begin
                    // Commit actual outcome into ghr by shifting in train_taken
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // No training this cycle: speculatively update ghr with predicted outcome
                ghr <= {ghr[5:0], predicted_taken};
            end
            // Else no training or prediction: ghr holds steady
        end
    end

endmodule