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

  // 2-bit saturating counter states:
  // 00 = strongly not taken
  // 01 = weakly not taken
  // 10 = weakly taken
  // 11 = strongly taken

  // Pattern History Table: 128 entries of 2-bit counters
  reg [1:0] pht [0:127];

  // 7-bit global branch history register
  reg [6:0] global_history;

  // Compute indices for prediction and training
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index = train_pc ^ train_history;

  // Read PHT entry for prediction (combinational)
  wire [1:0] predict_pht_entry = pht[predict_index];

  // Output prediction based on MSB of saturating counter
  // taken if counter >= 2 (2'b10 or 2'b11)
  assign predict_taken = (predict_pht_entry[1] == 1'b1) && predict_valid;

  // Output the history used for prediction - the global history at prediction time (before update)
  assign predict_history = (predict_valid) ? global_history : 7'b0;

  // Functions for saturating counter update
  function [1:0] counter_update;
    input [1:0] counter;
    input taken;
    begin
      if (taken) begin
        // Increment saturating counter, max 3
        if (counter != 2'b11)
          counter_update = counter + 1'b1;
        else
          counter_update = counter;
      end else begin
        // Decrement saturating counter, min 0
        if (counter != 2'b00)
          counter_update = counter - 1'b1;
        else
          counter_update = counter;
      end
    end
  endfunction

  integer i;

  // Initialization on asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      // Initialize PHT entries to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10;
      end
    end else begin
      // Training has priority over prediction for updating global_history
      if (train_valid) begin
        // Update PHT entry at train_index with actual outcome
        pht[train_index] <= counter_update(pht[train_index], train_taken);

        // If misprediction, recover global_history to train_history
        if (train_mispredicted)
          global_history <= train_history;
        else begin
          // No misprediction, keep global history as is (prediction update not applied)
          // Training does not update global_history unless mispredicted
        end
      end else if (predict_valid) begin
        // Prediction valid and no training this cycle: update global_history with predicted outcome
        // Update global_history by shifting in prediction
        global_history <= {global_history[5:0], predict_taken};
      end
      // else no update to global_history
    end
  end

endmodule