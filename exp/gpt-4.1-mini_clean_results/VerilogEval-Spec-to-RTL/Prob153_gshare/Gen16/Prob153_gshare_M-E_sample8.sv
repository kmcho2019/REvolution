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

    // PHT: 128 entries of 2-bit saturating counters
    // Encoding:
    // 00 = strongly not taken
    // 01 = weakly not taken
    // 10 = weakly taken
    // 11 = strongly taken
    reg [1:0] pht [0:127];

    // Committed global history register (reflects architecturally correct history)
    reg [6:0] ghr_committed;

    // Speculative global history register (used for prediction and speculation)
    reg [6:0] ghr_speculative;

    // Function to update saturating counter based on taken input
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

    // Compute prediction index and read current counter combinationally
    wire [6:0] predict_index = predict_pc ^ ghr_speculative;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predicted_taken = predict_counter[1]; // MSB is prediction bit

    // Assign outputs directly from combinational prediction
    assign predict_taken = (predict_valid) ? predicted_taken : 1'b0;
    assign predict_history = (predict_valid) ? ghr_speculative : 7'b0;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr_committed <= 7'b0;
            ghr_speculative <= 7'b0;
        end else begin
            // Training update has highest priority
            if (train_valid) begin
                // Update saturating counter at train index
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);

                if (train_mispredicted) begin
                    // On misprediction, recover committed GHR from provided history
                    ghr_committed <= train_history;
                    // Reset speculative GHR to committed to rollback speculation
                    ghr_speculative <= train_history;
                end else begin
                    // No misprediction: update committed GHR by shifting in actual outcome
                    ghr_committed <= {ghr_committed[5:0], train_taken};
                    // Speculative GHR unchanged (prediction speculation continues)
                end
            end else if (predict_valid) begin
                // No training: update speculative GHR by shifting in prediction
                ghr_speculative <= {ghr_speculative[5:0], predicted_taken};
                // Committed GHR unchanged
            end
            // If neither train nor predict valid, no GHR update

            // PHT updates only happen during training (done above)
        end
    end

endmodule