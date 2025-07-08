module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];
    reg [6:0] global_history;

    // Compute indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ global_history;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] predict_pht_entry = PHT[predict_index];

    // Predicted taken if MSB of saturating counter is 1
    assign predict_taken = predict_valid ? predict_pht_entry[1] : 1'b0;

    // Output current global history used for prediction
    assign predict_history = predict_valid ? global_history : 7'b0;

    // Saturating counter update function
    function [1:0] saturating_update;
        input [1:0] counter;
        input       taken;
        begin
            if (taken) begin
                // increment saturating counter unless at max (11)
                case (counter)
                    2'b00: saturating_update = 2'b01;
                    2'b01: saturating_update = 2'b10;
                    2'b10: saturating_update = 2'b11;
                    2'b11: saturating_update = 2'b11;
                    default: saturating_update = 2'b10;
                endcase
            end else begin
                // decrement saturating counter unless at min (00)
                case (counter)
                    2'b00: saturating_update = 2'b00;
                    2'b01: saturating_update = 2'b00;
                    2'b10: saturating_update = 2'b01;
                    2'b11: saturating_update = 2'b10;
                    default: saturating_update = 2'b01;
                endcase
            end
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly taken (2'b10)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b10;
            global_history <= 7'b0;
        end else begin
            // Priority: training takes precedence over prediction for global_history update

            if (train_valid) begin
                // Update PHT entry for training
                PHT[train_index] <= saturating_update(PHT[train_index], train_taken);

                if (train_mispredicted) begin
                    // Recover global history to state after mispredicted branch finishes
                    global_history <= train_history;
                end else if (predict_valid) begin
                    // Update global history with predicted taken bit from current prediction
                    // Only if no misprediction training
                    global_history <= {global_history[5:0], predict_pht_entry[1]};
                end
                else begin
                    // No prediction, no misprediction; no global history update
                    // global_history remains the same
                end
            end else if (predict_valid) begin
                // Only prediction valid, update global history by predicted taken bit
                global_history <= {global_history[5:0], predict_pht_entry[1]};
            end
            // else no update to global_history
        end
    end

endmodule