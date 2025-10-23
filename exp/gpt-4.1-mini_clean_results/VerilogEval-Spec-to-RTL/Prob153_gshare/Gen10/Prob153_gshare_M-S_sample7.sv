module TopModule (
    input          clk,
    input          areset,

    input          predict_valid,
    input  [6:0]   predict_pc,
    output reg     predict_taken,
    output reg [6:0] predict_history,

    input          train_valid,
    input          train_taken,
    input          train_mispredicted,
    input  [6:0]   train_history,
    input  [6:0]   train_pc
);

    // 2-bit saturating counter PHT: 128 entries
    reg [1:0] PHT [0:127];

    // Global History Register (speculative and committed combined)
    reg [6:0] ghr;

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
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    // Combinational prediction index and taken signal
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_taken_wire = predict_counter[1]; // MSB is taken bit

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            ghr <= 7'b0;
            predict_taken <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            // 1) Output current prediction and history before updates
            if (predict_valid) begin
                predict_taken <= predict_taken_wire;
                predict_history <= ghr;
            end

            // 2) Update PHT if training valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 3) Update GHR:
            //    - If mispredicted training, recover to train_history
            //    - Else if training valid and not mispredicted, update with actual outcome
            //    - Else if prediction valid and no mispredict training, update with predicted outcome
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid && !train_mispredicted) begin
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predict_taken_wire};
            end
            // else hold GHR unchanged
        end
    end

endmodule