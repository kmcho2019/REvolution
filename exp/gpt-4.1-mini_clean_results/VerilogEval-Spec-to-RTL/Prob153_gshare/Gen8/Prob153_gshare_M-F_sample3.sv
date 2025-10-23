module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0] predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 128-entry Pattern History Table (2-bit saturating counters)
    reg [1:0] PHT [0:127];

    // Global History Registers
    reg [6:0] committed_ghr;     // Architecturally committed GHR
    reg [6:0] speculative_ghr;   // Speculative GHR updated on predictions

    // Registered outputs reflecting GHR and PHT state used to make prediction
    reg [6:0] predict_history_reg;
    reg       predict_taken_reg;

    // Index calculations
    wire [6:0] predict_index  = predict_pc ^ speculative_ghr;
    wire [6:0] train_index    = train_pc ^ train_history;

    // Combinational read of PHT counters for prediction
    wire [1:0] predict_counter = PHT[predict_index];

    // Predicted taken bit from MSB of saturating counter
    wire       predict_taken_wire = predict_counter[1];

    // Saturating counter update function
    function [1:0] saturate_update;
        input [1:0] counter;
        input       taken;
        begin
            case(counter)
                2'b00: saturate_update = taken ? 2'b01 : 2'b00;
                2'b01: saturate_update = taken ? 2'b10 : 2'b00;
                2'b10: saturate_update = taken ? 2'b11 : 2'b01;
                2'b11: saturate_update = taken ? 2'b11 : 2'b10;
                default: saturate_update = 2'b01; // default weakly not taken
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1) begin
                PHT[i] <= 2'b01;
            end
            committed_ghr     <= 7'b0;
            speculative_ghr   <= 7'b0;
            predict_history_reg <= 7'b0;
            predict_taken_reg   <= 1'b0;
            predict_taken     <= 1'b0;
            predict_history   <= 7'b0;
        end else begin
            // 1) Register prediction outputs from *current* speculative_ghr and PHT state, only if predict_valid
            // This captures the history and prediction used before speculative_ghr update
            if (predict_valid) begin
                predict_history_reg <= speculative_ghr;
                predict_taken_reg   <= predict_taken_wire;
            end

            // 2) Update PHT on training if valid
            if (train_valid) begin
                PHT[train_index] <= saturate_update(PHT[train_index], train_taken);
            end

            // 3) Handle GHR updates:
            // Training misprediction recovery takes highest priority
            if (train_valid && train_mispredicted) begin
                // Recover both GHRs to committed history after misprediction
                committed_ghr   <= train_history;
                speculative_ghr <= train_history;
            end else begin
                // No mispredict training recovery
                if (train_valid && !train_mispredicted) begin
                    // Commit actual outcome to committed GHR
                    committed_ghr <= {committed_ghr[5:0], train_taken};
                    // Sync speculative GHR to committed GHR (flush speculative updates)
                    speculative_ghr <= {committed_ghr[5:0], train_taken};
                end else begin
                    // No training commit, update speculative GHR on prediction if valid
                    if (predict_valid) begin
                        // Append predicted bit to speculative_ghr
                        speculative_ghr <= {speculative_ghr[5:0], predict_taken_wire};
                    end
                    // else hold speculative_ghr as is
                end
            end

            // 4) Register outputs predict_taken and predict_history only when predict_valid
            // This ensures outputs are stable and reflect the *pre-update* prediction state
            if (predict_valid) begin
                predict_taken   <= predict_taken_reg;
                predict_history <= predict_history_reg;
            end
        end
    end

endmodule