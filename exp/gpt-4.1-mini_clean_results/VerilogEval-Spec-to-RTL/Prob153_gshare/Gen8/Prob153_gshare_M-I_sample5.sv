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

    // 2-bit saturating counter states encoding:
    // 00 = Strongly Not Taken (SN)
    // 01 = Weakly Not Taken (WN)
    // 10 = Weakly Taken (WT)
    // 11 = Strongly Taken (ST)

    reg [1:0] pht [0:127];
    reg [6:0] ghr_spec;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Combinational read of PHT for prediction (before training updates)
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs
    assign predict_taken   = (pht_predict_entry[1] == 1'b1); // MSB of saturating counter
    assign predict_history = ghr_spec;

    // Saturating counter update function: increment or decrement by one saturating at boundaries
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken; // 1 = branch taken, 0 = not taken
        begin
            if (taken) begin
                // Increment saturating counter, saturate at 2'b11
                if (state == 2'b11)
                    saturate_update = state;
                else
                    saturate_update = state + 2'b01;
            end else begin
                // Decrement saturating counter, saturate at 2'b00
                if (state == 2'b00)
                    saturate_update = state;
                else
                    saturate_update = state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_spec <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize all entries to WN (weakly not taken)
            end
        end else begin
            // 1. Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // 2. Update global history register with priority:
            //    a) If training valid & mispredicted: restore ghr_spec to train_history (recovery)
            //    b) Else if prediction valid: shift in predicted taken bit
            //    c) Else hold current history

            if (train_valid && train_mispredicted) begin
                // Recover global history from training info on misprediction
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted bit into ghr_spec
                // Predicted taken bit is pht_predict_entry[1] at this cycle (before update)
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // else: no change to ghr_spec
        end
    end

endmodule