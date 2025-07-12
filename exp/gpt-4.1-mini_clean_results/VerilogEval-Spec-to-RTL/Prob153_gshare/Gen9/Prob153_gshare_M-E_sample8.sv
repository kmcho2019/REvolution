module TopModule (
    input        clk,
    input        areset,

    // Prediction interface
    input        predict_valid,
    input  [6:0] predict_pc,
    output       predict_taken,
    output [6:0] predict_history,

    // Training interface
    input        train_valid,
    input        train_taken,
    input        train_mispredicted,
    input  [6:0] train_history,
    input  [6:0] train_pc
);

    // Saturating counter states encoding
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR)
    reg [6:0] ghr;

    // Functions for saturating increment/decrement of 2-bit counters
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case (val)
                SN: saturate_inc = WN;
                WN: saturate_inc = WT;
                WT: saturate_inc = ST;
                ST: saturate_inc = ST;
                default: saturate_inc = val;
            endcase
        end
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        begin
            case (val)
                ST: saturate_dec = WT;
                WT: saturate_dec = WN;
                WN: saturate_dec = SN;
                SN: saturate_dec = SN;
                default: saturate_dec = val;
            endcase
        end
    endfunction

    // Combinational predicted index and counter for current prediction request
    wire [6:0] predict_index = predict_pc ^ ghr;
    wire [1:0] predict_counter = pht[predict_index];
    wire       predict_taken_comb = (predict_counter[1] == 1'b1); // MSB indicates taken or not

    // Prediction outputs
    assign predict_taken = predict_valid ? predict_taken_comb : 1'b0;
    assign predict_history = predict_valid ? ghr : 7'b0;

    // Synchronous update of GHR and PHT
    always @(posedge clk or posedge areset) begin
        integer i;
        if (areset) begin
            ghr <= 7'b0;
            // Initialize PHT entries to Weakly Not Taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
        end else begin
            // Update PHT on training if valid
            if (train_valid) begin
                // Compute training index
                reg [6:0] train_index;
                train_index = train_pc ^ train_history;

                // Update saturating counter according to train_taken
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR with training mispredict priority
            if (train_valid && train_mispredicted) begin
                // Restore GHR after misprediction from train_history input
                ghr <= train_history;
            end else if (predict_valid) begin
                // Update GHR by shifting in predicted taken bit from current combinational prediction
                ghr <= {ghr[5:0], predict_taken_comb};
            end
            // else hold GHR unchanged
        end
    end

endmodule