module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] PHT [0:127];

    // Global History Register, updated speculatively and recovered on mispredictions
    reg [6:0] ghr;

    // Function: saturating counter update
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01;
            endcase
        end
    endfunction

    // Calculate prediction index and counter
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction

    // Calculate training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;
            ghr <= 7'd0;
            predict_taken <= 1'b0;
            predict_history <= 7'd0;
        end else begin
            // Update PHT on training
            if (train_valid)
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);

            // Update GHR: training with mispredict has highest priority
            if (train_valid && train_mispredicted) begin
                // Recover GHR to state after mispredicted branch
                ghr <= train_history;
            end else if (train_valid) begin
                // Update GHR with actual outcome
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Speculative update: shift in predicted bit
                ghr <= {ghr[5:0], predict_bit};
            end
            // Else hold GHR

            // Register prediction outputs only when valid
            if (predict_valid) begin
                predict_taken <= predict_bit;
                predict_history <= ghr;
            end
        end
    end

endmodule