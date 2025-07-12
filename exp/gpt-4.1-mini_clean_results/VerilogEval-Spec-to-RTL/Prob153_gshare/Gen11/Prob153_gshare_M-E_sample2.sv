module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table (PHT) of 128 entries, 2-bit saturating counters
    // States: 00 Strongly Not Taken, 01 Weakly Not Taken, 10 Weakly Taken, 11 Strongly Taken
    reg [1:0] pht [0:127];

    reg [6:0] ghr;       // Global history register

    // Wires for indexing PHT
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current PHT entry for prediction
    wire [1:0] predict_pht_entry = pht[predict_index];

    // Compute prediction bit for current prediction request
    wire predict_bit = predict_pht_entry[1];

    // Saturating counter update function
    function [1:0] sat_counter_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                // Increment saturating counter but saturate at 3
                sat_counter_update = (state == 2'b11) ? 2'b11 : state + 1;
            end else begin
                // Decrement saturating counter but saturate at 0
                sat_counter_update = (state == 2'b00) ? 2'b00 : state - 1;
            end
        end
    endfunction

    integer i;

    // Asynchronous reset and synchronous updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;

            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                pht[train_index] <= sat_counter_update(pht[train_index], train_taken);
            end

            // Priority for ghr update:
            // 1) If training mispredicted, recover ghr to train_history
            // 2) Else if prediction valid and no training mispredict in this cycle, shift in predicted bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], predict_bit};
            end else begin
                ghr <= ghr;
            end

            // Register prediction outputs to reflect stable ghr and PHT state at cycle start
            // Only update when predict_valid asserted, else hold previous outputs
            if (predict_valid) begin
                predict_taken <= predict_bit;
                predict_history <= ghr;
            end else begin
                // Hold outputs stable if no prediction valid this cycle
                predict_taken <= predict_taken;
                predict_history <= predict_history;
            end
        end
    end

endmodule