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

    // PHT states encoding (2-bit saturating counter)
    localparam STRONG_NOT_TAKEN = 2'b00;
    localparam WEAK_NOT_TAKEN   = 2'b01;
    localparam WEAK_TAKEN       = 2'b10;
    localparam STRONG_TAKEN     = 2'b11;

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Registers
    reg [6:0] ghr_shadow; // committed global history (updated on training non-mispredicted)
    reg [6:0] ghr_spec;   // speculative global history (used for prediction, updated on prediction and recovery)

    // Prediction combinational index and PHT read
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire       predict_taken_next = pht_predict_entry[1]; // MSB indicates taken/not taken

    // Training combinational index and PHT read
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    // Prediction outputs registered to align with stable predictor state
    reg        predict_taken_reg;
    reg  [6:0] predict_history_reg;

    // Saturating counter increment function
    function [1:0] saturate_inc(input [1:0] val);
        begin
            case (val)
                STRONG_TAKEN: saturate_inc = STRONG_TAKEN;
                default:      saturate_inc = val + 2'b01;
            endcase
        end
    endfunction

    // Saturating counter decrement function
    function [1:0] saturate_dec(input [1:0] val);
        begin
            case (val)
                STRONG_NOT_TAKEN: saturate_dec = STRONG_NOT_TAKEN;
                default:           saturate_dec = val - 2'b01;
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Async reset: Initialize all state
            ghr_shadow <= 7'b0;
            ghr_spec <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;

            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WEAK_NOT_TAKEN; // Initialize PHT entries to weakly not taken
        end else begin
            // --- PHT update on training if train_valid ---
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train_entry);
                else
                    pht[train_index] <= saturate_dec(pht_train_entry);
            end

            // --- Committed GHR update (shadow) on training non-mispredicted ---
            if (train_valid && !train_mispredicted) begin
                // Shift in actual taken outcome into committed history
                ghr_shadow <= {ghr_shadow[5:0], train_taken};
            end

            // --- Speculative GHR update ---
            // Priority: If train_mispredicted => restore speculative history from train_history (recovery)
            // Else if predict_valid => shift in predicted bit
            // Else hold

            if (train_valid && train_mispredicted) begin
                // Restore speculative history to trained history to recover from misprediction
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Update speculative GHR by shifting in predicted taken bit from current prediction
                ghr_spec <= {ghr_spec[5:0], predict_taken_next};
            end
            // else: hold ghr_spec

            // --- Register prediction outputs at clock edge ---
            // Only update if predict_valid asserted (to avoid latching old invalid outputs)
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_next;
                predict_history_reg <= ghr_spec; // Capture history used for prediction (before speculative update)
            end
            // Else hold outputs stable
        end
    end

    // Outputs driven from registered values (stable synchronous outputs)
    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule