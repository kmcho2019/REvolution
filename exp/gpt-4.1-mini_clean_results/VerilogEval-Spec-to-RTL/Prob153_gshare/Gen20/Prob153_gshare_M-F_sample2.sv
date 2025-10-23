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

    // Pattern History Table (PHT) with 128 entries of 2-bit saturating counters
    // State encoding: 00=StrongNT, 01=WeakNT, 10=WeakT, 11=StrongT
    reg [1:0] pht [0:127];

    // Global History Register (7 bits)
    reg [6:0] ghr;

    // Prediction outputs
    reg predict_taken_reg;

    // Combinational indices into PHT
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = pht[predict_index];

    wire predict_taken_wire = predict_counter[1];

    wire [6:0] train_index = train_pc ^ train_history;

    // Output assignments:
    // predict_taken is latched to avoid combinational glitches
    // predict_history is assigned combinationally to always reflect the GHR used for prediction (before update)
    assign predict_taken = predict_taken_reg;
    assign predict_history = ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 2'b01;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 2'b01;
            end
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
        end else begin
            // Latch prediction taken output if valid
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_wire;
            end

            // Update PHT on training
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update global history register (ghr)
            // Priority:
            // If training with mispredict flush, recover ghr to train_history
            // else if prediction valid, shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken_wire};
            end
            // else hold ghr steady
        end
    end

endmodule