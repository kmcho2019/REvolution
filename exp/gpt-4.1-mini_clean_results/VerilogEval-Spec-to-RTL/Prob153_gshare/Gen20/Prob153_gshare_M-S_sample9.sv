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
    // 00 = strongly not taken, 11 = strongly taken
    reg [1:0] pht [0:127];

    // Global history register
    reg [6:0] ghr;

    // Latch prediction outputs
    reg        predict_taken_reg;
    reg [6:0]  predict_history_reg;

    // Compute index for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entry for prediction
    wire [1:0] predict_counter = pht[predict_index];
    wire       predict_taken_wire = predict_counter[1];

    // Output assignments
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken)
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            else
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= 2'b01;
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch prediction outputs when valid
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
                predict_history_reg <= ghr;  // history before prediction update
            end

            // Update PHT and ghr on training
            if (train_valid) begin
                // Update saturating counter
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
                // Update or recover ghr on misprediction
                if (train_mispredicted)
                    ghr <= train_history; // flush and recover history
                else
                    ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Update ghr with predicted taken bit if no flush
                ghr <= {ghr[5:0], predict_taken_wire};
            end
            // else ghr holds steady
        end
    end

endmodule