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

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR) - working register updated at clock edge
    reg [6:0] ghr;

    // Function: saturating counter next state update
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

    // Combinational stable GHR used for prediction outputs and indexing
    wire [6:0] predict_ghr = ghr;

    // Prediction index: XOR of PC and stable GHR
    wire [6:0] predict_index = predict_pc ^ predict_ghr;

    // Read PHT counter combinationally using stable index
    wire [1:0] predict_counter = pht[predict_index];

    // Predicted taken bit is MSB of saturating counter
    wire predicted_taken = predict_counter[1];

    // Prediction outputs reflect stable GHR and PHT state before any update
    assign predict_taken = predict_valid ? predicted_taken : 1'b0;
    assign predict_history = predict_ghr;

    // Training index and current counter value (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] train_counter = pht[train_index];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(train_counter, train_taken);
            end

            // Update GHR with priority:
            // 1) If training mispredict, recover GHR to train_history
            // 2) Else if prediction valid, update GHR with predicted bit
            // 3) Else keep GHR unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], predicted_taken};
            end
            // else no GHR update
        end
    end

endmodule