module TopModule (
  input          clk,
  input          areset,

  input          predict_valid,
  input  [6:0]   predict_pc,
  output         predict_taken,
  output [6:0]   predict_history,

  input          train_valid,
  input          train_taken,
  input          train_mispredicted,
  input  [6:0]   train_history,
  input  [6:0]   train_pc
);

// Pattern History Table: 128 entries of 2-bit saturating counters
// States: 2'b00 Strongly Not Taken, 2'b01 Weakly Not Taken
//         2'b10 Weakly Taken,     2'b11 Strongly Taken
reg [1:0] pht [0:127];

// Global branch history register (7 bits)
reg [6:0] global_history;

// Wire for PHT index for prediction
wire [6:0] predict_index;
assign predict_index = predict_pc ^ global_history;

// Read PHT state for prediction (combinational)
wire [1:0] predict_pht_state;
assign predict_pht_state = pht[predict_index];

// Prediction: taken if MSB of counter is 1
assign predict_taken = (predict_pht_state[1] == 1'b1);
assign predict_history = global_history;

// Compute PHT index for training
wire [6:0] train_index;
assign train_index = train_pc ^ train_history;

// For update logic:
// Next PHT state after training
function [1:0] saturating_counter_update;
  input [1:0] current;
  input       taken;
  begin
    case(current)
      2'b00: saturating_counter_update = taken ? 2'b01 : 2'b00;
      2'b01: saturating_counter_update = taken ? 2'b10 : 2'b00;
      2'b10: saturating_counter_update = taken ? 2'b11 : 2'b01;
      2'b11: saturating_counter_update = taken ? 2'b11 : 2'b10;
      default: saturating_counter_update = 2'b01;
    endcase
  end
endfunction

// Next global history for prediction update (shift in predicted direction)
wire predicted_taken_next = predict_taken;
wire [6:0] global_history_next_pred = {global_history[5:0], predicted_taken_next};

// Next global history for training update (restore if mispredicted)
wire [6:0] global_history_next_train = train_mispredicted ? train_history : global_history;

// Global history update priority:
// 1. If training valid and mispredicted, update global_history to train_history
// 2. else if training valid (not mispredicted), no change to global_history
// 3. else if prediction valid, update global_history with predicted outcome
// 4. else keep global_history
reg [6:0] global_history_next;
integer i;

// Training update: compute next PHT state for the training index
reg [1:0] next_train_pht_state;

always @(*) begin
  if (train_valid) begin
    next_train_pht_state = saturating_counter_update(pht[train_index], train_taken);
  end else begin
    next_train_pht_state = 2'b00; // dummy value, won't be used if train_valid=0
  end
end

// Update logic on clock edge and asynchronous reset
always @(posedge clk or posedge areset) begin
  if (areset) begin
    // Reset global history and PHT entries
    global_history <= 7'b0;
    for (i = 0; i < 128; i = i+1)
      pht[i] <= 2'b01; // weakly not taken on reset
  end else begin
    // Update PHT if training valid
    if (train_valid) begin
      pht[train_index] <= next_train_pht_state;
    end

    // Update global history with priority rules
    if (train_valid && train_mispredicted) begin
      // Restore global history to train_history on misprediction
      global_history <= train_history;
    end else if (train_valid && !train_mispredicted) begin
      // No global history update on training without mispredict
      global_history <= global_history;
    end else if (predict_valid) begin
      // Update global history by shifting in predicted outcome
      global_history <= global_history_next_pred;
    end else begin
      global_history <= global_history;
    end
  end
end

endmodule