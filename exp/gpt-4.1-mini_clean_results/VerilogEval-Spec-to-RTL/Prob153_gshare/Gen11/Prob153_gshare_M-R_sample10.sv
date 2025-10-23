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

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (state)
    reg [6:0] ghr;

    // Prediction pipeline registers to hold outputs stable throughout the cycle
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    // Function: saturating counter update (2-bit)
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                saturate_update = (state == 2'b11) ? 2'b11 : state + 1'b1;
            end else begin
                saturate_update = (state == 2'b00) ? 2'b00 : state - 1'b1;
            end
        end
    endfunction

    // Combinational indices for prediction and training
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Read PHT entries combinationally (pre-update)
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry = pht[train_index];

    // Combinational predicted taken bit for prediction
    wire predict_taken_comb = pht_predict_entry[1]; // MSB is taken bit

    // Assign outputs from registers (registered outputs ensure stable timing)
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr <= 7'b0;
            // Initialize all PHT entries to weakly not taken (2'b01)
            for (i=0; i<128; i=i+1)
                pht[i] <= 2'b01;

            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // Latch prediction outputs from previous combinational reads
            // Only update if predict_valid, else hold previous values
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_comb;
                predict_history_reg <= ghr;
            end

            // Update PHT on training if valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end

            // Update GHR with priority to training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Recover GHR to train_history if mispredicted
                ghr <= train_history;
            end else if (predict_valid) begin
                // Shift in the predicted bit into GHR
                ghr <= {ghr[5:0], predict_taken_comb};
            end
            // Else keep GHR unchanged
        end
    end

endmodule