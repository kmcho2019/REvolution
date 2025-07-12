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

    // Global History Register
    reg [6:0] ghr;

    // Function: saturating counter update for taken/not-taken
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

    // Combinational prediction logic
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = PHT[predict_index];
    wire       predict_bit = predict_counter[1]; // MSB is prediction bit

    // Training index
    wire [6:0] train_index = train_pc ^ train_history;

    integer i;

    // Output assignments: combinationally driven
    assign predict_taken = predict_valid ? predict_bit : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'd0;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1)
                PHT[i] <= 2'b01;
            ghr <= 7'b0;
        end else begin
            // Update PHT on training if valid
            if (train_valid)
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);

            // Update GHR: training mispredict has highest priority
            if (train_valid && train_mispredicted) begin
                // Recover GHR to known good state after mispredicted branch
                ghr <= train_history;
            end else if (train_valid) begin
                // Update GHR with actual branch outcome
                ghr <= {ghr[5:0], train_taken};
            end else if (predict_valid) begin
                // Speculative update of GHR with predicted outcome
                ghr <= {ghr[5:0], predict_bit};
            end
            // else hold ghr
        end
    end

endmodule