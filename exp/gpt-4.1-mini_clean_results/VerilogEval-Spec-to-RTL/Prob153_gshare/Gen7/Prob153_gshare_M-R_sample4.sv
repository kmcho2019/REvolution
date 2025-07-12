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

    // Pipeline stage 0 registers: capture inputs and GHR to form PHT index
    reg        predict_valid_s0;
    reg [6:0]  predict_pc_s0;
    reg [6:0]  ghr_s0;

    // Registered PHT read address (stage 0 index)
    reg [6:0]  pht_read_addr;

    // PHT read data output (combinational from synchronous RAM at read address)
    wire [1:0] pht_read_data = pht[pht_read_addr];

    // Pipeline stage 1 registers: capture PHT data and stage 0 inputs for output generation
    reg        predict_valid_s1;
    reg [6:0]  predict_pc_s1;
    reg [6:0]  ghr_s1;
    reg [1:0]  pht_data_s1;

    // Saturating counter update functions
    function [1:0] saturate_inc(input [1:0] val);
        saturate_inc = (val == ST) ? ST : val + 1'b1;
    endfunction

    function [1:0] saturate_dec(input [1:0] val);
        saturate_dec = (val == SN) ? SN : val - 1'b1;
    endfunction

    // Compute training index
    wire [6:0] train_index = train_pc ^ train_history;

    // Prediction taken from PHT MSB in stage 1
    wire predict_taken_s1 = pht_data_s1[1];

    integer i;

    // Sequential logic: reset, PHT update, GHR update, pipeline registers
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Initialize PHT entries to WN (01)
            for (i = 0; i < 128; i = i + 1)
                pht[i] <= WN;

            ghr_spec <= 7'b0;

            // Clear pipeline stages
            predict_valid_s0 <= 1'b0;
            predict_pc_s0    <= 7'b0;
            ghr_s0           <= 7'b0;
            pht_read_addr    <= 7'b0;

            predict_valid_s1 <= 1'b0;
            predict_pc_s1    <= 7'b0;
            ghr_s1           <= 7'b0;
            pht_data_s1      <= WN;
        end else begin
            // Pipeline stage 0 captures current prediction inputs and current GHR
            predict_valid_s0 <= predict_valid;
            predict_pc_s0    <= predict_pc;
            ghr_s0           <= ghr_spec;

            // PHT read address registered at clock edge (synchronous RAM read)
            // If prediction valid, compute index; else hold previous address
            if (predict_valid)
                pht_read_addr <= predict_pc ^ ghr_spec;
            else
                pht_read_addr <= pht_read_addr; // hold

            // Pipeline stage 1 captures PHT data read for previous stage 0 index
            predict_valid_s1 <= predict_valid_s0;
            predict_pc_s1    <= predict_pc_s0;
            ghr_s1           <= ghr_s0;
            pht_data_s1      <= pht_read_data;

            // PHT update on training valid (synchronous)
            if (train_valid) begin
                if (train_taken)
                    pht[train_index] <= saturate_inc(pht[train_index]);
                else
                    pht[train_index] <= saturate_dec(pht[train_index]);
            end

            // GHR update logic with training priority on misprediction
            if (train_valid && train_mispredicted) begin
                // Restore GHR to train_history on misprediction training
                ghr_spec <= train_history;
            end else if (predict_valid_s1) begin
                // Update GHR with predicted bit (from stage 1 prediction)
                ghr_spec <= {ghr_spec[5:0], pht_data_s1[1]};
            end
            // else hold ghr_spec unchanged
        end
    end

    // Outputs driven from stage 1 registered prediction and history (stable and aligned)
    assign predict_taken = predict_valid_s1 ? predict_taken_s1 : 1'b0;
    assign predict_history = predict_valid_s1 ? ghr_s1 : 7'b0;

endmodule