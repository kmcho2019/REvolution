module TopModule (
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output predict_taken,
    output [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Parameters for 2-bit saturating counters
localparam WT = 2'b10; // Weakly Taken initial state
localparam ST = 2'b11;
localparam WN = 2'b01;
localparam SN = 2'b00;

// Global history register
reg [6:0] ghr;

// Pattern history table: 128 entries of 2-bit saturating counters
reg [1:0] pht [0:127];

// Wires and registers for prediction
wire [6:0] pred_index;
reg [6:0] pred_history_reg;
reg [1:0] pred_counter; // PHT entry read at prediction cycle

assign pred_index = predict_pc ^ ghr;
assign predict_history = pred_history_reg;
assign predict_taken = (pred_counter[1] == 1'b1); // Taken if MSB of counter is 1

// Index for training
wire [6:0] train_index = train_pc ^ train_history;

// Read PHT entry for prediction (combinational read)
wire [1:0] pht_pred_val = pht[pred_index];

// Internal register to hold prediction counter for output
always @(*) begin
    if (predict_valid)
        pred_counter = pht_pred_val;
    else
        pred_counter = 2'b00; // default when no prediction, not taken
end

// Save the GHR used for prediction output
always @(posedge clk or posedge areset) begin
    if (areset) begin
        pred_history_reg <= 7'b0;
    end else if (predict_valid) begin
        pred_history_reg <= ghr;
    end
end

integer i;

// Sequential logic for GHR and PHT updates
always @(posedge clk or posedge areset) begin
    if (areset) begin
        ghr <= 7'b0;
        // Initialize PHT entries to weakly taken
        for (i=0; i<128; i=i+1) begin
            pht[i] <= WT;
        end
    end else begin
        // Update PHT if training valid
        if (train_valid) begin
            // Update saturating counter for train_index
            case (pht[train_index])
                SN: pht[train_index] <= train_taken ? WN : SN;
                WN: pht[train_index] <= train_taken ? WT : SN;
                WT: pht[train_index] <= train_taken ? ST : WN;
                ST: pht[train_index] <= train_taken ? ST : WT;
                default: pht[train_index] <= WT; // default safe state
            endcase
        end

        // Update GHR: training misprediction takes priority
        if (train_valid && train_mispredicted) begin
            // Recover GHR to train_history (state after mispredicted branch commits)
            ghr <= train_history;
        end else if (predict_valid) begin
            // Update GHR with predicted direction bit
            ghr <= {ghr[5:0], predict_taken};
        end
        // Else keep GHR unchanged
    end
end

endmodule