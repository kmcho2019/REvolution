module TopModule(
    input         clk,
    input         areset,

    // Prediction interface
    input         predict_valid,
    input  [6:0]  predict_pc,
    output reg    predict_taken,
    output reg [6:0]  predict_history,

    // Training interface
    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

    // 2-bit saturating counter states
    localparam [1:0]
        SN = 2'b00, // Strongly not taken
        WN = 2'b01, // Weakly not taken
        WT = 2'b10, // Weakly taken
        ST = 2'b11; // Strongly taken

    // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
    reg [1:0] pht [0:127];

    // Combinational read port signals
    reg [6:0] predict_pc_reg;
    reg       predict_valid_reg;
    reg [6:0] ghr_spec_reg;

    // Registered read data from PHT for prediction index
    reg [1:0] pht_rdata;   // Data read out from PHT for prediction

    // Global History Registers
    reg [6:0] ghr_commit; // committed global history (architectural)
    reg [6:0] ghr_spec;   // speculative global history (updated on prediction, restored on recovery)

    // Prediction index for PHT read
    wire [6:0] predict_index = predict_pc_reg ^ ghr_spec_reg;

    // Training index for PHT update
    wire [6:0] train_index = train_pc ^ train_history;

    // Saturating counter next state logic for training update
    function [1:0] saturate_update;
        input [1:0] state;
        input       taken;
        begin
            case (state)
                SN: saturate_update = taken ? WN : SN;
                WN: saturate_update = taken ? WT : SN;
                WT: saturate_update = taken ? ST : WN;
                ST: saturate_update = taken ? ST : WT;
                default: saturate_update = WN; // default safe state
            endcase
        end
    endfunction

    integer i;

    // PHT synchronous read and write logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            pht_rdata <= WN; // default read data after reset
        end else begin
            // Read PHT at index predict_index synchronously
            pht_rdata <= pht[predict_index];
        end
    end

    // Latch prediction inputs for stable indexing and history capture
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_pc_reg    <= 7'b0;
            predict_valid_reg <= 1'b0;
            ghr_spec_reg      <= 7'b0;
        end else begin
            if (predict_valid) begin
                predict_pc_reg    <= predict_pc;
                predict_valid_reg <= 1'b1;
                ghr_spec_reg      <= ghr_spec;
            end else begin
                // No prediction this cycle
                predict_valid_reg <= 1'b0;
                // Hold old values (not strictly necessary)
            end
        end
    end

    // Predict outputs registered one cycle after latching inputs and reading PHT
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            predict_taken   <= 1'b0;
            predict_history <= 7'b0;
        end else begin
            if (predict_valid_reg) begin
                predict_taken   <= pht_rdata[1];       // MSB of saturating counter = prediction
                predict_history <= ghr_spec_reg;       // History used for prediction
            end else begin
                predict_taken   <= 1'b0;
                predict_history <= 7'b0;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ghr_commit <= 7'b0;
            ghr_spec <= 7'b0;
            for (i=0; i<128; i=i+1)
                pht[i] <= WN; // Initialize PHT entries to weakly not taken
        end else begin
            // Update PHT on training
            if (train_valid) begin
                pht[train_index] <= saturate_update(pht[train_index], train_taken);
            end

            // Update committed global history on non-mispredicted training branches
            if (train_valid && !train_mispredicted) begin
                ghr_commit <= {ghr_commit[5:0], train_taken};
            end

            // Update speculative global history (ghr_spec) with priority:
            // 1) Training misprediction recovery (restore history)
            // 2) Else if prediction was valid last cycle, shift in predicted bit from that prediction
            // 3) Else hold history
            if (train_valid && train_mispredicted) begin
                // Recover speculative history to after mispredicted branch completes
                ghr_spec <= train_history;
            end else if (predict_valid_reg) begin
                // Shift in predicted taken bit from previous prediction into speculative history
                ghr_spec <= {ghr_spec[5:0], pht_rdata[1]};
            end
            // else ghr_spec remains unchanged
        end
    end

endmodule