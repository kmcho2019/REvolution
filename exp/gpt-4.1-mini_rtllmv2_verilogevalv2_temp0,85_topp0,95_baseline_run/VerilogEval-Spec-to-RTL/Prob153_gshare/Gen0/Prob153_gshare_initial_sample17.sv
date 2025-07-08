module TopModule (
    input  wire        clk,
    input  wire        areset,

    input  wire        predict_valid,
    input  wire [6:0]  predict_pc,
    output reg         predict_taken,
    output reg [6:0]   predict_history,

    input  wire        train_valid,
    input  wire        train_taken,
    input  wire        train_mispredicted,
    input  wire [6:0]  train_history,
    input  wire [6:0]  train_pc
);

// 128-entry PHT of 2-bit saturating counters
// States: 2'b00 = strongly not taken, 2'b01 = weakly not taken
//         2'b10 = weakly taken,     2'b11 = strongly taken
reg [1:0] pht [0:127];

// Global history register - 7 bits
reg [6:0] global_history;

// Indices for prediction and training
wire [6:0] predict_index = predict_pc ^ global_history;
wire [6:0] train_index   = train_pc ^ train_history;

// Read PHT entries for prediction and training
wire [1:0] predict_pht_state;
wire [1:0] train_pht_state;

assign predict_pht_state = pht[predict_index];
assign train_pht_state   = pht[train_index];

// For prediction output combinational logic
wire predict_taken_comb = predict_pht_state[1]; 
// MSB of saturating counter is prediction: 1 => taken, 0 => not taken

// Next state calculation for training update of saturating counter
function [1:0] saturating_counter_next;
    input [1:0] current_state;
    input       taken;
    begin
        case (current_state)
            2'b00: saturating_counter_next = taken ? 2'b01 : 2'b00;
            2'b01: saturating_counter_next = taken ? 2'b10 : 2'b00;
            2'b10: saturating_counter_next = taken ? 2'b11 : 2'b01;
            2'b11: saturating_counter_next = taken ? 2'b11 : 2'b10;
            default: saturating_counter_next = 2'b10;
        endcase
    end
endfunction

integer i;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset: initialize PHT to weakly taken (2'b10), global history to 0
        global_history <= 7'b0;
        for (i = 0; i < 128; i = i + 1) begin
            pht[i] <= 2'b10;
        end
        predict_taken   <= 0;
        predict_history <= 7'b0;
    end else begin
        // Prediction output logic (combinational read from PHT)
        if (predict_valid) begin
            predict_taken   <= predict_taken_comb;
            predict_history <= global_history;
        end else begin
            // Maintain previous outputs if no valid prediction
            predict_taken   <= 0;
            predict_history <= 7'b0;
        end

        // Update PHT and global history at posedge clk
        // Training update has priority over prediction update for global history
        if (train_valid) begin
            // Update the PHT saturating counter at train_index with actual taken
            pht[train_index] <= saturating_counter_next(pht[train_index], train_taken);

            // If mispredicted, recover global history to train_history
            if (train_mispredicted) begin
                global_history <= train_history;
            end else begin
                // If no misprediction, and prediction also valid for a different index,
                // global_history updated according to prediction if prediction_valid and not same index as train_index
                // But training takes precedence, so only update global_history from prediction if no misprediction
                // However, if train and predict target same index, prediction sees old PHT state but training updates at posedge.
                // Per problem statement, training and prediction on same cycle: training takes precedence for updating global history.
                if (predict_valid && (predict_index != train_index)) begin
                    // Update global history with prediction taken
                    global_history <= {global_history[5:0], predict_taken_comb};
                end
                // Else no prediction or same index as training, so no prediction update of history
            end
        end else begin
            // No training: if prediction valid, update global history with prediction
            if (predict_valid) begin
                global_history <= {global_history[5:0], predict_taken_comb};
            end
            // Else no update to global history
        end
    end
end

endmodule