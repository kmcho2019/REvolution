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

    // 2-bit saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly Not Taken
        WN = 2'b01, // Weakly Not Taken
        WT = 2'b10, // Weakly Taken
        ST = 2'b11; // Strongly Taken

    reg [1:0] pht [0:127];    // Pattern History Table

    reg [6:0] ghr;            // Global History Register (committed)

    // Compute indices
    wire [6:0] predict_idx = predict_pc ^ ghr;
    wire [6:0] train_idx   = train_pc   ^ train_history;

    // Read PHT entries combinationally
    wire [1:0] pht_predict_entry = pht[predict_idx];
    wire       pht_predict_taken = pht_predict_entry[1]; // MSB indicates prediction

    wire [1:0] pht_train_entry = pht[train_idx];

    // Registered outputs to align with clock
    reg predict_taken_reg;
    reg [6:0] predict_history_reg;

    integer i;

    // Saturation helpers
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT to Weakly Not Taken
            for (i = 0; i < 128; i = i + 1) begin
                pht[i] <= WN;
            end
            ghr <= 7'b0;
            predict_taken_reg <= 1'b0;
            predict_history_reg <= 7'b0;
        end else begin
            // --- Training update ---
            if (train_valid) begin
                // Update PHT entry with actual branch outcome
                if (train_taken)
                    pht[train_idx] <= saturate_inc(pht_train_entry);
                else
                    pht[train_idx] <= saturate_dec(pht_train_entry);
            end

            // --- GHR update ---
            // If misprediction, restore GHR to train_history (recover)
            // Else, update GHR by shifting in train_taken (commit)
            if (train_valid && train_mispredicted) begin
                ghr <= train_history;
            end else if (train_valid && !train_mispredicted) begin
                ghr <= {ghr[5:0], train_taken};
            end
            // else hold GHR

            // --- Prediction output registers ---
            // Output prediction only when valid
            if (predict_valid) begin
                predict_taken_reg <= pht_predict_taken;
                predict_history_reg <= ghr; // history before any training update (stable committed GHR)
            end
            // else hold outputs stable
        end
    end

    assign predict_taken = predict_taken_reg;
    assign predict_history = predict_history_reg;

endmodule