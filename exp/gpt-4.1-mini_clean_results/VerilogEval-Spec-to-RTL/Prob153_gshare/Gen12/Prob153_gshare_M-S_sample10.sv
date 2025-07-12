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

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Compute indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Current PHT values at indices (asynchronously read)
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs: taken if MSB of saturating counter is 1
    assign predict_taken = predict_valid && pht_predict_entry[1];
    assign predict_history = ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state != 2'b11)
                    saturate_update = state + 2'b01;
                else
                    saturate_update = state;
            end else begin
                if (state != 2'b00)
                    saturate_update = state - 2'b01;
                else
                    saturate_update = state;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            if (train_valid) begin
                // Update PHT entry for training
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
                // If mispredicted, recover global history to train_history
                if (train_mispredicted)
                    ghr <= train_history;
                else if (predict_valid) begin
                    // Update global history with predicted taken bit (shift in prediction)
                    ghr <= {ghr[5:0], pht_predict_entry[1]};
                end
                else begin
                    // No prediction update, keep ghr
                    ghr <= ghr;
                end
            end else if (predict_valid) begin
                // No training, update ghr with prediction bit
                ghr <= {ghr[5:0], pht_predict_entry[1]};
            end
            // else no update to ghr
        end
    end

endmodule