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

    // PHT table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global history register
    reg [6:0] ghr;

    // Calculate indices
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction is combinational: use current pht and ghr
    wire [1:0] pht_pred_entry = pht[predict_index];
    assign predict_taken = predict_valid ? pht_pred_entry[1] : 1'b0; // MSB as taken bit
    assign predict_history = ghr;

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            case(state)
                SN: saturate_update = taken ? WN : SN;
                WN: saturate_update = taken ? WT : SN;
                WT: saturate_update = taken ? ST : WN;
                ST: saturate_update = taken ? ST : WT;
                default: saturate_update = WN; // Safe default
            endcase
        end
    endfunction

    integer i;

    // Sequential updates of PHT and GHR
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to weakly not taken (WN)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr <= 7'b0;
        end else begin
            // Update PHT on training valid
            if (train_valid)
                pht[train_index] <= saturate_update(pht[train_index], train_taken);

            // Update GHR:
            // Priority: if training valid & mispredicted -> recover train_history
            // else if prediction valid & no mispredict training -> shift in predicted bit
            // else keep unchanged
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid && !(train_valid && train_mispredicted)) begin
                ghr <= {ghr[5:0], pht_pred_entry[1]};
            end
        end
    end

endmodule