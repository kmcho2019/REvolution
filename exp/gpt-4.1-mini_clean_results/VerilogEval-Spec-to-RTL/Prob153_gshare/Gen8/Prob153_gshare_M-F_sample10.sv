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

    // Saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table: 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Global History Register (speculative)
    reg [6:0] ghr_spec;

    // Pipeline stage 0 registers: capture prediction inputs and current GHR
    reg        predict_valid_s0;
    reg [6:0]  predict_pc_s0;
    reg [6:0]  ghr_s0;

    // Registered PHT read address (for synchronous RAM read)
    reg [6:0] pht_read_addr;

    // PHT read data output (combinational read from synchronous RAM)
    wire [1:0] pht_read_data = pht[pht_read_addr];

    // Pipeline stage 1 registers: hold prediction info and PHT data for output
    reg        predict_valid_s1;
    reg [6:0]  predict_pc_s1;
    reg [6:0]  ghr_s1;
    reg [1:0]  pht_data_s1;

    // Helper functions for saturating counter increment/decrement
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    // Compute training index from train_pc and train_history
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction taken bit from PHT MSB at stage 1
    wire predict_taken_s1 = pht_data_s1[1];

    integer i;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to WN (weakly not taken)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;

            // Reset GHR
            ghr_spec <= 7'b0;

            // Clear prediction pipeline registers
            predict_valid_s0 <= 1'b0;
            predict_pc_s0    <= 7'b0;
            ghr_s0           <= 7'b0;
            pht_read_addr    <= 7'b0;

            predict_valid_s1 <= 1'b0;
            predict_pc_s1    <= 7'b0;
            ghr_s1           <= 7'b0;
            pht_data_s1      <= WN;
        end else begin
            // Stage 0 pipeline: latch prediction inputs and current GHR
            predict_valid_s0 <= predict_valid;
            predict_pc_s0    <= predict_pc;
            ghr_s0           <= ghr_spec;

            // Register PHT read address based on current prediction inputs and GHR
            if (predict_valid)
                pht_read_addr <= predict_pc ^ ghr_spec;
            else
                pht_read_addr <= pht_read_addr; // Hold if no prediction valid

            // Stage 1 pipeline: latch data from stage 0 including PHT read output
            predict_valid_s1 <= predict_valid_s0;
            predict_pc_s1    <= predict_pc_s0;
            ghr_s1           <= ghr_s0;
            pht_data_s1      <= pht_read_data;

            // Update PHT on training
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // Update GHR with training priority on misprediction
            if (train_valid && train_mispredicted) begin
                // Restore GHR to the saved history after mispredicted branch
                ghr_spec <= train_history;
            end else if (predict_valid_s1) begin
                // Update GHR by shifting in the predicted bit from PHT output at stage 1
                // This corresponds to the prediction made at stage 0, now completed
                ghr_spec <= {ghr_spec[5:0], pht_data_s1[1]};
            end
            // Otherwise, hold GHR unchanged
        end
    end

    // Output assignments, valid only when stage 1 prediction is valid
    assign predict_taken = predict_valid_s1 ? predict_taken_s1 : 1'b0;
    assign predict_history = predict_valid_s1 ? ghr_s1 : 7'b0;

endmodule