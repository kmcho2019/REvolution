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

    // 2-bit saturating counters:
    // 00 = Strongly Not Taken
    // 01 = Weakly Not Taken
    // 10 = Weakly Taken
    // 11 = Strongly Taken

    reg [1:0] pht [0:127];

    reg [6:0] ghr; // Committed global history

    // Compute indices for PHT
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read current PHT entry for prediction (combinational)
    wire [1:0] pht_entry = pht[predict_index];

    // Predict taken if MSB of 2-bit counter is 1 (states 10,11)
    assign predict_taken = pht_entry[1];

    // Output the stable global history used for prediction
    assign predict_history = ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                // increment saturating to max 3
                saturate_update = (state == 2'b11) ? state : state + 2'b01;
            end else begin
                // decrement saturating to min 0
                saturate_update = (state == 2'b00) ? state : state - 2'b01;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset global history and PHT entries
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01; // Weakly Not Taken
        end else begin
            // Update PHT entry on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update global history with priority:
            // 1) Training mispredicted: recover to train_history
            // 2) Else if prediction valid: shift in predicted bit from current prediction
            // 3) Else: keep unchanged

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in the prediction bit from current PHT entry indexed by predict_pc ^ ghr
                ghr <= {ghr[5:0], pht_entry[1]};
            end else begin
                ghr <= ghr; // No change
            end
        end
    end

endmodule