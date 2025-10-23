module TopModule (
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

    // Saturating counter states for PHT entries
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT) 128 x 2-bit counters
    reg [1:0] pht [0:127];

    // GHR registers
    reg [6:0] ghr_commit; // Committed (true) global history
    reg [6:0] ghr_spec;   // Speculative global history used for prediction and prediction updates

    // Pipeline registers for prediction inputs
    reg predict_valid_r;
    reg [6:0] predict_pc_r;
    reg [6:0] ghr_spec_r;  // GHR used to index PHT at prediction

    // PHT read address and data registers
    reg [6:0] pht_index_r;      // Registered index for synchronous RAM read
    reg [1:0] pht_data_r;       // Registered PHT data output (read data)

    integer i;

    // Saturating counter increment and decrement functions
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    // Compute combinational PHT index for training update
    wire [6:0] train_index = train_pc ^ train_history;

    // Compute prediction index combinationally from registered inputs
    wire [6:0] predict_index = predict_pc_r ^ ghr_spec_r;

    // Prediction taken bit derived from registered PHT data MSB
    wire predict_taken_next = pht_data_r[1];

    // Output registers for prediction outputs
    reg predict_taken_out;
    reg [6:0] predict_history_out;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to Weakly Not Taken
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;

            ghr_commit   <= 7'b0;
            ghr_spec     <= 7'b0;

            // Clear prediction pipeline registers
            predict_valid_r <= 1'b0;
            predict_pc_r    <= 7'b0;
            ghr_spec_r      <= 7'b0;

            pht_index_r     <= 7'b0;
            pht_data_r      <= WN;

            predict_taken_out   <= 1'b0;
            predict_history_out <= 7'b0;
        end else begin
            // ---- Prediction input registration (pipeline stage 1) ----
            predict_valid_r <= predict_valid;
            predict_pc_r    <= predict_pc;
            ghr_spec_r      <= ghr_spec;

            // Register PHT read address (index) for prediction
            pht_index_r <= predict_pc_r ^ ghr_spec_r;

            // ---- Synchronous RAM read: read PHT entry for indexed address ----
            // PHT read at address pht_index_r, registered to pht_data_r
            // Modeling synchronous RAM behavior
            pht_data_r <= pht[pht_index_r];

            // ---- Prediction output generation (pipeline stage 2) ----
            if (predict_valid_r) begin
                predict_taken_out   <= pht_data_r[1];
                predict_history_out <= ghr_spec_r;
            end

            // ---- Training update ----
            if (train_valid) begin
                // Update the PHT entry for train_index on next clock edge
                // Using train_history and train_pc for index and train_taken for direction
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);

                // Update committed GHR on every training (committed history)
                ghr_commit <= {ghr_commit[5:0], train_taken};
            end

            // ---- Speculative GHR update ----
            // Priority:
            // 1) If mispredicted training in this cycle, recover ghr_spec from train_history
            // 2) Else if prediction valid in this cycle, update ghr_spec with prediction outcome
            // 3) Else hold ghr_spec
            if (train_valid && train_mispredicted) begin
                // Recovery due to misprediction flush
                ghr_spec <= train_history;
            end else if (predict_valid) begin
                // Speculatively update with predicted direction
                ghr_spec <= {ghr_spec[5:0], predict_taken_next};
            end
            // else: hold ghr_spec unchanged
        end
    end

    assign predict_taken = predict_taken_out;
    assign predict_history = predict_history_out;

endmodule