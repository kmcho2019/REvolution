module TopModule (
    input         clk,
    input         areset,

    input         predict_valid,
    input  [6:0]  predict_pc,
    output        predict_taken,
    output [6:0]  predict_history,

    input         train_valid,
    input         train_taken,
    input         train_mispredicted,
    input  [6:0]  train_history,
    input  [6:0]  train_pc
);

// PHT parameters
localparam PHT_SIZE = 128;
localparam PHT_INDEX_BITS = 7;

// 2-bit saturating counter states
localparam [1:0]
    SN = 2'b00,  // Strongly Not Taken
    WN = 2'b01,  // Weakly Not Taken
    WT = 2'b10,  // Weakly Taken
    ST = 2'b11;  // Strongly Taken

// Global branch history register
reg [6:0] global_history_r, global_history_next;

// Pattern History Table (PHT)
reg [1:0] pht [0:PHT_SIZE-1];

// Wires and regs for indices
wire [6:0] predict_index;
wire [6:0] train_index;

// Intermediate read values
reg [1:0] pht_predict_entry;
reg [1:0] pht_train_entry;

// Prediction taken and output history signals
reg predict_taken_r;
reg [6:0] predict_history_r;

// Compute indices by XOR PC and history
assign predict_index = predict_pc ^ global_history_r;
assign train_index = train_pc ^ train_history;

// Output assignments
assign predict_taken = predict_taken_r;
assign predict_history = predict_history_r;

// Read PHT entries combinationally
// PHT is a reg array, reads are synchronous, so we read in an always @* with pht stored in a reg
integer i;
always @(*) begin
    pht_predict_entry = pht[predict_index];
    pht_train_entry = pht[train_index];
end

// Predict taken if counter MSB = 1
wire predict_taken_now = pht_predict_entry[1];

// Saturating counter update function
function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
        case (counter)
            SN: saturate_update = taken ? WN : SN;
            WN: saturate_update = taken ? WT : SN;
            WT: saturate_update = taken ? ST : WN;
            ST: saturate_update = taken ? ST : WT;
            default: saturate_update = SN;
        endcase
    end
endfunction

// Sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Reset global history
        global_history_r <= 7'b0;
        // Reset PHT entries to weakly not taken (01)
        for (i = 0; i < PHT_SIZE; i = i + 1) begin
            pht[i] <= WN;
        end

        predict_taken_r <= 1'b0;
        predict_history_r <= 7'b0;
    end else begin
        // Default outputs: if predict_valid, output current PHT predict result and global history
        if (predict_valid) begin
            predict_taken_r <= predict_taken_now;
            predict_history_r <= global_history_r;
        end else begin
            // If no prediction requested, keep last outputs (or clear)
            // Keeping last outputs so predict_taken and history hold last valid prediction.
            predict_taken_r <= predict_taken_r;
            predict_history_r <= predict_history_r;
        end

        // PHT update on train_valid
        if (train_valid) begin
            // Update PHT entry at train_index with saturating counter update using train_taken
            pht[train_index] <= saturate_update(pht_train_entry, train_taken);
        end

        // Update global history register with precedence for train_mispredicted
        // If train_valid and train_mispredicted, global history is recovered to train_history
        // Else if predict_valid and no misprediction training, global history updated with predicted branch direction
        if (train_valid && train_mispredicted) begin
            // Recover global history to the history after the mispredicted branch completes execution
            global_history_r <= train_history;
        end else if (predict_valid) begin
            // Update global history by shifting in predicted taken bit
            global_history_r <= {global_history_r[5:0], predict_taken_now};
        end
        // else no update to global_history_r (holds)
    end
end

endmodule