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

  // Read saturating counters combinationally
  wire [1:0] predict_counter = pht[predict_index];
  wire [1:0] train_counter   = pht[train_index];

  // Predict taken if MSB of saturating counter is 1
  assign predict_taken = predict_valid ? predict_counter[1] : 1'b0;
  assign predict_history = global_history;

  // Helper function: saturating counter update
  function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1'b1;
      end else begin
        saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1'b1;
      end
    end
  endfunction

  integer i;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // weakly taken
    end else begin
      // Training updates PHT if valid
      if (train_valid) begin
        pht[train_index] <= saturate_update(train_counter, train_taken);
      end

      // Update global_history
      // Priority: train_mispredicted > train_valid (no mispred) > predict_valid
      if (train_valid && train_mispredicted) begin
        // On misprediction restore GHR to train_history (flush)
        global_history <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        // Training with no misprediction: update GHR based on predicted bit (current GHR)
        // Append predicted taken bit from current GHR (not from train input, but from pht)
        // The predicted taken bit from predict interface used only if predict_valid
        // But spec says after training with no misprediction, update GHR with predicted taken if prediction valid
        // Here predicted taken is the MSB of pht[predict_index]
        // But if predict_valid is 0, no update to GHR
        if (predict_valid) begin
          // Shift left by 1 and insert predict_taken bit
          global_history <= {global_history[5:0], predict_counter[1]};
        end else begin
          // No prediction this cycle, keep GHR unchanged
          global_history <= global_history;
        end
      end else if (!train_valid && predict_valid) begin
        // No training, but prediction valid: update GHR by predicted bit
        global_history <= {global_history[5:0], predict_counter[1]};
      end else begin
        // No change
        global_history <= global_history;
      end
    end
  end

endmodule