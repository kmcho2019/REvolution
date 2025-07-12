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

    // 2-bit saturating counter states:
    // 00 = Strongly Not Taken (SN)
    // 01 = Weakly Not Taken   (WN)
    // 10 = Weakly Taken       (WT)
    // 11 = Strongly Taken     (ST)

    reg [1:0] pht [0:127];

    reg [6:0] ghr_reg;  // Committed global history, stable during cycle for prediction outputs
    reg [6:0] ghr_spec; // Speculative global history, updated at clock edge

    // Prediction index uses committed history ghr_reg (stable this cycle)
    wire [6:0] predict_index = predict_pc ^ ghr_reg;

    // Training index uses given train_history (per spec)
    wire [6:0] train_index = train_pc ^ train_history;

    // Combinationally read PHT entries for prediction before any update at clock edge
    wire [1:0] pht_predict_entry = pht[predict_index];

    // Predict outputs use pht_predict_entry and stable ghr_reg
    assign predict_taken = (pht_predict_entry[1] == 1'b1);
    assign predict_history = ghr_reg;

    // Saturating counter update function
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

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_reg <= 7'b0;
            ghr_spec <= 7'b0;
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= 2'b01; // Initialize all PHT entries to Weakly Not Taken
            end
        end else begin
            // 1. Update PHT if training valid
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // 2. Update speculative global history (ghr_spec) with priority:
            //    a) If training valid & mispredicted: recover to train_history
            //    b) Else if prediction valid: shift in predicted bit using committed ghr_reg
            //    c) Else hold current speculative history

            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Use committed ghr_reg (not ghr_spec) for correct one-cycle history chaining
                ghr_spec <= {ghr_reg[5:0], pht_predict_entry[1]};
            end
            // else no change to ghr_spec

            // 3. Commit the speculative history for next cycle's prediction
            ghr_reg <= ghr_spec;
        end
    end

endmodule