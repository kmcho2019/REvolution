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

    // Global History Register
    reg [6:0] ghr;

    // Function to update 2-bit saturating counter
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
    endfunction

    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = pht[predict_index];

    assign predict_taken = predict_counter[1];  // MSB is prediction
    assign predict_history = ghr;

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            for (i=0; i<128; i=i+1)
                pht[i] <= 2'b01; // weakly not taken initialization
        end else begin
            // Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update GHR
            // Priority: training recovery if mispredicted > else prediction update if valid > else keep
            if (train_valid && train_mispredicted) begin
                // Recover GHR on mispredict
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in predicted taken bit at clock edge
                ghr <= {ghr[5:0], predict_counter[1]};
            end
            // else ghr unchanged
        end
    end

endmodule