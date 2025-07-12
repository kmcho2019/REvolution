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
    // States:
    // 00 Strongly Not Taken
    // 01 Weakly Not Taken
    // 10 Weakly Taken
    // 11 Strongly Taken
    reg [1:0] pht [0:127];

    // Global history registers
    reg [6:0] ghr_reg;      // committed history state (used for prediction outputs)
    reg [6:0] ghr_spec;     // speculative next history state before clock edge

    // Register prediction inputs to synchronize outputs
    reg        predict_valid_r;
    reg  [6:0] predict_pc_r;

    // Compute indices into PHT using XOR of pc and history
    wire [6:0] predict_index = predict_pc_r ^ ghr_reg;
    wire [6:0] train_index   = train_pc ^ train_history;

    // Read current PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire [1:0] pht_train_entry   = pht[train_index];

    // Predict taken if MSB of saturating counter is 1
    assign predict_taken   = predict_valid_r ? pht_predict_entry[1] : 1'b0;
    assign predict_history = predict_valid_r ? ghr_reg : 7'b0;

    // Function to update saturating counter state for training
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            if (taken) begin
                if (state == 2'b11)
                    saturate_update = state;
                else
                    saturate_update = state + 2'b01;
            end else begin
                if (state == 2'b00)
                    saturate_update = state;
                else
                    saturate_update = state - 2'b01;
            end
        end
    endfunction

    integer i;

    // Combinational logic for speculative history update
    // Priority: if train_valid && train_mispredicted => recover to train_history
    // else if predict_valid => shift in predicted bit from PHT entry indexed by predict_pc_r and ghr_reg
    // else hold current speculative history
    wire [6:0] predicted_ghr_next = {ghr_reg[5:0], pht_predict_entry[1]};
    wire [6:0] ghr_next_comb;
    assign ghr_next_comb = (train_valid && train_mispredicted) ? train_history :
                           (predict_valid_r) ? predicted_ghr_next :
                           ghr_spec; // hold speculative

    // On clock edge, update registers and PHT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_reg       <= 7'b0;
            ghr_spec      <= 7'b0;
            predict_valid_r <= 1'b0;
            predict_pc_r    <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // weakly not taken
            end
        end else begin
            // Register prediction inputs to align output timing
            predict_valid_r <= predict_valid;
            predict_pc_r    <= predict_pc;

            // Commit the speculative history to the committed GHR register
            ghr_reg  <= ghr_next_comb;
            ghr_spec <= ghr_next_comb;

            // Update PHT only on training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht_train_entry, train_taken);
            end
        end
    end

endmodule