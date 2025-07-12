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

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Prediction pipeline registers to hold stable outputs
    reg        predict_taken_r;
    reg  [6:0] predict_history_r;

    // Index wires
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction bit

    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            saturate_update =
                taken ? ((counter == 2'b11) ? 2'b11 : counter + 1)
                      : ((counter == 2'b00) ? 2'b00 : counter - 1);
        end
    endfunction

    // Output assignments from pipeline registers
    assign predict_taken = predict_taken_r;
    assign predict_history = predict_history_r;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken_r <= 1'b0;
            predict_history_r <= 7'b0;
        end else begin
            // 1) Capture prediction outputs first, before any update to GHR or PHT
            if (predict_valid) begin
                predict_history_r <= ghr;       // Capture current GHR used for prediction
                predict_taken_r <= predict_bit; // Capture prediction bit from current PHT
            end
            // else: hold predict_taken_r and predict_history_r

            // 2) Update PHT if training valid (at clock edge)
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 3) Update GHR with priority:
            //    - If training mispredict: recover GHR to train_history
            //    - Else if training valid (no mispredict): shift in train_taken
            //    - Else if prediction valid: shift in predicted bit (speculative)
            //    - Else hold GHR unchanged

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_bit};
            end
            // else ghr unchanged (hold)
        end
    end

endmodule