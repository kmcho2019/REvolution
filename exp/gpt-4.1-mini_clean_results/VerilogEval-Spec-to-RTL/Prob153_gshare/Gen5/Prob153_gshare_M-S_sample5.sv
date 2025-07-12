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

    reg [6:0] ghr_spec;   // Speculative global history for prediction
    reg [6:0] ghr_commit; // Committed global history from training

    // Compute prediction index and PHT entry (combinational)
    wire [6:0] predict_index = predict_pc ^ ghr_spec;
    wire [1:0] pht_predict_entry = pht[predict_index];
    wire       predict_taken_next = pht_predict_entry[1]; // MSB is taken/not taken

    // Compute training index and PHT entry (combinational)
    wire [6:0] train_index = train_pc ^ train_history;
    wire [1:0] pht_train_entry = pht[train_index];

    // Registered outputs to align outputs with prediction timing
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    integer i;

    // Saturating counter update functions
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset PHT to weakly not taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;
            ghr_spec <= 7'b0;
            ghr_commit <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // --- Training update ---
            if (train_valid) begin
                // Update PHT entry for training
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht_train_entry);
                else
                    pht[train_index] <= saturate_dec(pht_train_entry);
            end

            // --- Update committed GHR on non-mispredicted training ---
            if (train_valid && !train_mispredicted) begin
                ghr_commit <= {ghr_commit[5:0], train_taken};
            end

            // --- Speculative GHR update ---
            // Priority: misprediction recovery overwrites speculative GHR
            if (train_valid && train_mispredicted) begin
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                ghr_spec <= {ghr_spec[5:0], predict_taken_next};
            end
            // else: hold ghr_spec

            // --- Register prediction outputs ---
            // Only update outputs on predict_valid to avoid latching invalid data
            if (predict_valid) begin
                predict_taken_reg <= predict_taken_next;
                predict_history_reg <= ghr_spec; // history before update
            end
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule