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

    // Global history register (speculative, updated on prediction or training)
    reg [6:0] ghr;

    // Register to hold the predict_history output
    reg [6:0] predict_history_reg;

    // Indexes
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Asynchronous reads for PHT entries at predict and train indices
    wire [1:0] pht_predict_state = pht[predict_index];
    wire [1:0] pht_train_state = pht[train_index];

    // Output assignments
    assign predict_taken = predict_valid && pht_predict_state[1];
    assign predict_history = predict_history_reg;

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
            // Initialize PHT entries to Weakly Not Taken (2'b01)
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01;
            end
            ghr <= 7'd0;
            predict_history_reg <= 7'd0;
        end else begin
            // At clock edge, update PHT and ghr
            if (train_valid) begin
                // Update PHT entry indexed by train_index using train_taken
                pht[train_index] <= saturate_update(pht_train_state, train_taken);

                if (train_mispredicted) begin
                    // Recover ghr to train_history on misprediction training
                    ghr <= train_history;
                end else begin
                    // Correct prediction training: update ghr with actual outcome
                    ghr <= {ghr[5:0], train_taken};
                end

                // Prediction that happens simultaneously does not update ghr
                // Output predict_history as current ghr if predict_valid
                if (predict_valid) begin
                    predict_history_reg <= ghr;
                end

            end else if (predict_valid) begin
                // No training, but prediction valid
                // Output predict_history as current ghr before update
                predict_history_reg <= ghr;
                // Update ghr with predicted bit (MSB of PHT counter)
                ghr <= {ghr[5:0], pht_predict_state[1]};
            end else begin
                // No training and no prediction: no changes
                // Keep predict_history_reg stable (don't update)
            end
        end
    end

endmodule