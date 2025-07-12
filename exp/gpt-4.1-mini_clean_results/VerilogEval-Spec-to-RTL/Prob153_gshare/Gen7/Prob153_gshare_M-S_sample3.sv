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

    // 2-bit saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register (speculative)
    reg [6:0] ghr_spec;

    // Compute prediction index from pc xor speculative history
    wire [6:0] predict_index = predict_pc ^ ghr_spec;

    // Read PHT entry combinationally for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Prediction outputs combinationally driven from current predictor state
    assign predict_taken = pht_predict_entry[1];  // MSB indicates taken
    assign predict_history = ghr_spec;

    // Compute training index from train_pc xor train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter next state logic
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            case (state)
                SN: saturate_update = taken ? WN : SN;
                WN: saturate_update = taken ? WT : SN;
                WT: saturate_update = taken ? ST : WN;
                ST: saturate_update = taken ? ST : WT;
                default: saturate_update = WN; // safe default
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_spec <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN; // Initialize PHT entries to weakly not taken
            end
        end else begin
            // Update PHT on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update global history with priority:
            // 1) If misprediction training: recover to train_history
            // 2) Else if prediction valid: shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                ghr_spec <= {ghr_spec[5:0], pht_predict_entry[1]};
            end
            // else hold current history
        end
    end

endmodule