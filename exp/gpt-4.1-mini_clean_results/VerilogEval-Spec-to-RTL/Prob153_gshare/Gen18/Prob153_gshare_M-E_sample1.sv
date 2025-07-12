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

    // PHT: 128 x 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Committed Global History Register: stable history state before prediction speculative update
    reg [6:0] ghr_committed;

    // Index wires
    wire [6:0] predict_index = predict_pc ^ ghr_committed;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predicted_taken = predict_counter[1];

    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] train_counter = pht[train_index];

    // Combinational outputs: based on committed GHR (before speculative update)
    assign predict_taken = predict_valid ? predicted_taken : 1'b0;
    assign predict_history = ghr_committed;

    // Saturating counter next state logic
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = 2'b11;
                else
                    saturate_update = state + 1'b1;
            end else begin
                if (state == 2'b00)
                    saturate_update = 2'b00;
                else
                    saturate_update = state - 1'b1;
            end
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr_committed <= 7'b0;
        end else begin
            // Update PHT on training (synchronous)
            if (train_valid) begin
                pht[train_index] <= saturate_update(train_counter, train_taken);
            end

            // Update committed GHR
            if (train_valid && train_mispredicted) begin
                // Recover GHR to branch history on misprediction recovery
                ghr_committed <= train_history;
            end else if (predict_valid) begin
                // Speculative GHR update with predicted taken
                ghr_committed <= {ghr_committed[5:0], predicted_taken};
            end
            // else keep ghr_committed unchanged
        end
    end

endmodule