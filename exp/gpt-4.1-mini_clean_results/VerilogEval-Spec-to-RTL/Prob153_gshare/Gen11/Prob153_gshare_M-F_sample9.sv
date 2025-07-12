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
    reg predict_taken_r;
    reg [6:0] predict_history_r;

    // Prediction index and counter wires
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction bit

    // Training index for PHT update
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // weakly not taken default
            endcase
        end
    endfunction

    // Output assignments from pipeline registers
    assign predict_taken = predict_taken_r;
    assign predict_history = predict_history_r;

    // Main sequential block for updates and pipeline registers
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
            // 1) Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 2) Update prediction pipeline registers when predict_valid is high
            //    These registers hold the GHR and prediction bit *at the prediction request cycle*
            //    so outputs match the timing spec exactly.
            if (predict_valid) begin
                predict_history_r <= ghr;
                predict_taken_r <= predict_bit;
            end else begin
                // Hold last values to keep outputs stable
                predict_history_r <= predict_history_r;
                predict_taken_r <= predict_taken_r;
            end

            // 3) Update GHR with priority:
            //    - If training mispredict: recover GHR to train_history
            //    - Else if training valid (no mispredict): shift in train_taken
            //    - Else if prediction valid: shift in predicted bit (speculative)
            //    - Else hold GHR

            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_bit};
            end else begin
                ghr <= ghr;
            end
        end
    end

endmodule