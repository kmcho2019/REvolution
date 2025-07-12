module TopModule(
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

  // Pattern History Table: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Global History Register
  reg [6:0] global_history;

  // Indices for prediction and training
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Read saturating counters combinationally from PHT before training writes occur
  // Prediction always sees PHT state before training updates (sync RAM behavior)
  wire [1:0] predict_counter = pht[predict_index];
  wire [1:0] train_counter   = pht[train_index];

  // Predict taken if MSB of saturating counter is 1, else not taken
  assign predict_taken = predict_valid ? predict_counter[1] : 1'b0;

  // Output the current GHR as predict_history
  assign predict_history = global_history;

  // Function: saturating counter update on training
  function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        saturate_update = (counter == 2'b11) ? 2'b11 : (counter + 1'b1);
      end else begin
        saturate_update = (counter == 2'b00) ? 2'b00 : (counter - 1'b1);
      end
    end
  endfunction

  integer i;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Asynchronous reset: initialize PHT and GHR
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // weakly taken
    end else begin
      // 1) Update PHT for training if valid
      if (train_valid) begin
        pht[train_index] <= saturate_update(train_counter, train_taken);
      end

      // 2) Update global_history with priority:
      // train_valid & train_mispredicted -> restore GHR to train_history
      // else train_valid & !train_mispredicted -> update GHR by predicted bit for train instruction
      // else if !train_valid & predict_valid -> update GHR by predicted bit for prediction instruction
      // else keep GHR

      if (train_valid && train_mispredicted) begin
        // Misprediction flush: restore GHR to train_history
        global_history <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        // Training without misprediction: update GHR by predicted bit for training PC and history
        // predicted bit is MSB of train_counter (before update)
        global_history <= {global_history[5:0], train_counter[1]};
      end else if (!train_valid && predict_valid) begin
        // Prediction only: update GHR by predicted bit for prediction PC and global_history
        global_history <= {global_history[5:0], predict_counter[1]};
      end else begin
        // No change
        global_history <= global_history;
      end
    end
  end

endmodule