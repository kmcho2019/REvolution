module TopModule (
    input        clk,
    input        areset,

    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // Pattern History Table: 128 entries, 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Register (7 bits)
    reg [6:0] GHR;

    // Wires for indexing
    wire [6:0] predict_index = predict_pc ^ GHR;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = PHT[predict_index];
    wire [1:0] pht_train_entry   = PHT[train_index];

    // Prediction is MSB of PHT entry (2-bit saturating counter)
    assign predict_taken = (pht_predict_entry[1] == 1'b1);

    // The predictor outputs the GHR used for prediction (before update)
    assign predict_history = GHR;

    // Saturating counter update function
    function [1:0] saturating_counter_update;
        input [1:0] old_value;
        input       taken;
        begin
            if (taken) begin
                if (old_value != 2'b11)
                    saturating_counter_update = old_value + 1;
                else
                    saturating_counter_update = old_value;
            end else begin
                if (old_value != 2'b00)
                    saturating_counter_update = old_value - 1;
                else
                    saturating_counter_update = old_value;
            end
        end
    endfunction

    integer i;

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: clear GHR and PHT entries
            GHR <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b10; // weakly taken as initial state
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturating_counter_update(PHT[train_index], train_taken);
            end

            // Update GHR:
            // Training with misprediction has highest priority: restore GHR
            // Else if predict_valid and not overridden by training mispredict, update GHR with prediction
            if (train_valid && train_mispredicted) begin
                // Restore GHR to train_history on misprediction
                GHR <= train_history;
            end else if (predict_valid) begin
                // Update GHR with prediction bit
                // Prediction taken = MSB of PHT[predict_index]
                GHR <= {GHR[5:0], predict_taken};
            end
            // else no GHR update
        end
    end

endmodule