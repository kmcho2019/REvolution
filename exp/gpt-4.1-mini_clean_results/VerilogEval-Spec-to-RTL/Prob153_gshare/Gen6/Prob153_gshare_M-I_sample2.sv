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

    // PHT 2-bit saturating states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    reg [1:0] pht [0:127];

    // Speculative global history register used for prediction and updated speculatively
    reg [6:0] ghr_spec;

    // Compute prediction index (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr_spec;

    // Combinational read of PHT entry for prediction
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire       predict_taken_next = pht_predict_entry[1]; // MSB is taken/not taken

    // Compute training index (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    // Registered outputs to align outputs with prediction timing
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    integer i;

    // Saturating counter increment function
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    // Saturating counter decrement function
    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT entries to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr_spec <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // --- Register the prediction outputs BEFORE updating ghr_spec ---
            // This preserves the prediction history and taken bit used to produce the prediction,
            // per specification that output history corresponds to the history BEFORE updating.

            if (predict_valid) begin
                predict_taken_reg <= predict_taken_next;
                predict_history_reg <= ghr_spec; // history before shifting in predicted bit
            end

            // --- Training update to PHT ---
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train_entry);
                else
                    pht[train_index] <= saturate_dec(pht_train_entry);
            end

            // --- Update speculative GHR ---
            // Priority: If mispredicted training this cycle, recover speculative GHR from train_history
            // Else if prediction valid, shift in predicted taken bit
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                ghr_spec <= {ghr_spec[5:0], predict_taken_next};
            end
            // else hold ghr_spec
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule