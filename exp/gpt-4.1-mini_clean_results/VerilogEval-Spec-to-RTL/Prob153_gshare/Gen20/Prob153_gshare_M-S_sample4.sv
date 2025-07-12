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
        SN = 2'b00,
        WN = 2'b01,
        WT = 2'b10,
        ST = 2'b11;

    // PHT: 128 entries of 2-bit counters
    reg [1:0] pht [0:127];
    reg [6:0] ghr;

    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] pht_pred_entry = pht[predict_index];

    // Prediction outputs combinational from current GHR and PHT
    assign predict_taken = predict_valid ? pht_pred_entry[1] : 1'b0;
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
                default: saturate_update = WN;
            endcase
        end
    endfunction

    integer i;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr <= 7'd0;
        end else begin
            // Update PHT on training valid
            if (train_valid)
                pht[train_pc ^ train_history] <= saturate_update(pht[train_pc ^ train_history], train_taken);

            // Update GHR: training misprediction recovery takes priority
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (predict_valid) begin
                ghr <= {ghr[5:0], pht_pred_entry[1]};
            end
        end
    end

endmodule