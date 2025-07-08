module TopModule(
    input clk,
    input areset,

    input predict_valid,
    input [6:0] predict_pc,
    output reg predict_taken,
    output reg [6:0] predict_history,

    input train_valid,
    input train_taken,
    input train_mispredicted,
    input [6:0] train_history,
    input [6:0] train_pc
);

// Parameters
localparam PHT_SIZE = 128;
localparam COUNTER_BITS = 2;

// PHT: 128 x 2-bit saturating counters
// 2-bit saturating counter encoding:
// 2'b00: strongly not taken
// 2'b01: weakly not taken
// 2'b10: weakly taken
// 2'b11: strongly taken
reg [COUNTER_BITS-1:0] PHT [0:PHT_SIZE-1];

// Global History Register (7 bits)
reg [6:0] GHR;

// Index function: xor of PC and GHR
wire [6:0] predict_index = predict_pc ^ GHR;
wire [6:0] train_index = train_pc ^ train_history;

// Read current PHT entry for prediction (combinational)
wire [1:0] predict_counter = PHT[predict_index];

// Prediction output
wire predict_taken_w = predict_counter[1]; // MSB of 2-bit counter

// Sequential logic
integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset: Initialize PHT and GHR
        GHR <= 7'b0;
        for (i = 0; i < PHT_SIZE; i = i +1) begin
            PHT[i] <= 2'b01; // weakly not taken to avoid bias
        end
        predict_taken <= 1'b0;
        predict_history <= 7'b0;
    end else begin
        // Output registered prediction signals
        if (predict_valid) begin
            predict_taken <= predict_taken_w;
            predict_history <= GHR;
        end else begin
            // When predict_valid==0, outputs hold last valid value
            // Alternatively could hold default values, but spec doesn't specify.
        end

        // Training update at posedge clk
        if (train_valid) begin
            // Update PHT entry indexed by train_pc ^ train_history
            // Saturating counter update:
            // if train_taken==1, increment counter (max 3)
            // else decrement counter (min 0)
            case (PHT[train_index])
                2'b00: PHT[train_index] <= train_taken ? 2'b01 : 2'b00;
                2'b01: PHT[train_index] <= train_taken ? 2'b10 : 2'b00;
                2'b10: PHT[train_index] <= train_taken ? 2'b11 : 2'b01;
                2'b11: PHT[train_index] <= train_taken ? 2'b11 : 2'b10;
                default: PHT[train_index] <= 2'b01; // safe default
            endcase
        end

        // Update GHR at posedge clk:
        // Priority:
        // if train_valid & train_mispredicted: recover GHR to train_history
        // else if predict_valid: update GHR with predicted taken bit

        if (train_valid && train_mispredicted) begin
            GHR <= train_history;
        end else if (predict_valid) begin
            GHR <= {GHR[5:0], predict_taken_w};
        end
        // else GHR holds
    end
end

endmodule