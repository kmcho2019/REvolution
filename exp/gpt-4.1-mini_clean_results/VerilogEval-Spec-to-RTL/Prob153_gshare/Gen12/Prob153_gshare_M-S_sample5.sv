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

    // Pattern History Table (PHT): 128 entries, 2-bit saturating counters
    reg [1:0] pht [0:127];
    reg [6:0] ghr; // global branch history register

    // Index calculations
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // PHT read for prediction (combinational, pre-update)
    wire [1:0] predict_counter = pht[predict_index];

    // Prediction outputs
    assign predict_taken = (predict_valid) ? predict_counter[1] : 1'b0;
    assign predict_history = (predict_valid) ? ghr : 7'b0;

    // 2-bit saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state != 2'b11)
                    saturate_update = state + 1'b1;
                else
                    saturate_update = state;
            end else begin
                if (state != 2'b00)
                    saturate_update = state - 1'b1;
                else
                    saturate_update = state;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize to weakly not taken
            end
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update global history register:
            // Priority: training misprediction recovery > prediction update > hold

            if (train_valid && train_mispredicted) begin
                // Recover ghr to train_history on misprediction
                ghr <= train_history;
            end else if (predict_valid) begin
                // Speculatively shift in prediction outcome bit from current PHT entry
                ghr <= {ghr[5:0], predict_counter[1]};
            end
            // else hold current ghr
        end
    end

endmodule