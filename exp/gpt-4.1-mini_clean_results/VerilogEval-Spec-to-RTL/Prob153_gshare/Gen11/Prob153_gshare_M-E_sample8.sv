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
        SN = 2'b00, // Strongly Not Taken
        WN = 2'b01, // Weakly Not Taken
        WT = 2'b10, // Weakly Taken
        ST = 2'b11; // Strongly Taken

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (GHR) holding current global history
    reg [6:0] ghr_reg;

    // Pipeline register to hold the GHR used for last prediction output
    reg [6:0] ghr_pred;

    // Register holding predicted taken bit from last prediction,
    // used to update GHR on next cycle (pipeline aligned)
    reg       pred_taken_next;

    // Compute prediction and training indices (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr_reg;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read the PHT entry at prediction index (combinational)
    wire [1:0] predict_counter = pht[predict_index];

    // Predicted taken bit derived from MSB of saturating counter
    wire predicted_taken_bit = predict_counter[1];

    // Outputs reflect the *latched* history and PHT state used in prediction
    assign predict_taken   = predict_valid ? pred_taken_next : 1'b0;
    assign predict_history = predict_valid ? ghr_pred : 7'b0;

    // Saturating counter increment function
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case(val)
                SN: saturate_inc = WN;
                WN: saturate_inc = WT;
                WT: saturate_inc = ST;
                ST: saturate_inc = ST;
                default: saturate_inc = val;
            endcase
        end
    endfunction

    // Saturating counter decrement function
    function [1:0] saturate_dec(input [1:0] val);
        begin
            case(val)
                ST: saturate_dec = WT;
                WT: saturate_dec = WN;
                WN: saturate_dec = SN;
                SN: saturate_dec = SN;
                default: saturate_dec = val;
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize GHR, pipeline reg and PHT entries
            ghr_reg       <= 7'b0;
            ghr_pred      <= 7'b0;
            pred_taken_next <= 1'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN; // Initialize to Weakly Not Taken
            end
        end else begin
            // Update PHT entry on training request
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR with priority to training misprediction recovery
            if (train_valid && train_mispredicted) begin
                // Restore GHR after mispredicted branch completes execution
                ghr_reg <= train_history;
            end else if (predict_valid) begin
                // Shift in previous predicted taken bit into GHR
                ghr_reg <= {ghr_reg[5:0], pred_taken_next};
            end
            // else hold GHR

            // Latch GHR for prediction output when predict_valid asserted,
            // to correspond to the exact GHR used for prediction
            if (predict_valid) begin
                ghr_pred <= ghr_reg;
                // Update predicted taken bit for next cycle's GHR update
                pred_taken_next <= predicted_taken_bit;
            end
            // else hold previous ghr_pred and pred_taken_next
        end
    end

endmodule