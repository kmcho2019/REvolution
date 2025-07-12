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

    // Global History Register (single for both prediction and training)
    reg [6:0] ghr;

    // Output registers for prediction
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Index wires for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read current prediction counter
    wire [1:0] predict_counter = pht[predict_index];
    wire predict_taken_wire = predict_counter[1];

    // Output assignments
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch prediction outputs if valid
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= ghr;
            end

            // Training update takes priority over prediction for history update
            if (train_valid) begin
                // Update PHT entry based on actual outcome
                pht[train_index] <= saturate_update(pht[train_index], train_taken);

                if (train_mispredicted) begin
                    // Flush: recover history to flush history
                    ghr <= train_history;
                end else begin
                    // Update history with actual branch outcome
                    ghr <= {ghr[5:0], train_taken};
                end
            end else if (predict_valid) begin
                // No training this cycle, update history with predicted outcome
                ghr <= {ghr[5:0], predict_taken_wire};
            end
            // Else no change to history if neither predict nor train valid
        end
    end

endmodule