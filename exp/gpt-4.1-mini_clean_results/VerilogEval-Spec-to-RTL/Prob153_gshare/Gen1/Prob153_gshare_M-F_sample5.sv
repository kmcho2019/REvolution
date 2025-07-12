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

  // Pattern History Table (PHT), 128 entries of 2-bit saturating counters
  // Use synchronous read memory approach:
  reg [1:0] pht [0:127];

  // Registered outputs for PHT read at predict_index and train_index to avoid combinational read of memory
  reg [1:0] predict_pht_entry_reg;

  // Global branch history register (7 bits)
  reg [6:0] global_history;

  // Compute indices
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // For reading PHT at predict_index synchronously,
  // we'll capture pht[predict_index] at clock edge or combinationally, but avoid combinational read directly:
  // So, we read at combinational for prediction output using registered global_history, 
  // but because PHT is memory, we register prediction PHT entry at clock edge for stable output
  // To do this, we'll register predict_index and read PHT inside clocked always block

  reg [6:0] predict_index_reg;
  reg       predict_valid_reg;

  // Predicted taken stored for global_history update
  reg       predicted_taken_reg;

  integer i;

  // Asynchronous reset and synchronous updates for PHT and global_history
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      predict_pht_entry_reg <= 2'b10; // default weakly taken
      predict_index_reg <= 7'b0;
      predict_valid_reg <= 1'b0;
      predicted_taken_reg <= 1'b0;
      // Initialize PHT entries to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10;
      end
    end else begin
      // Register predict_valid and predict_index for stable PHT read
      predict_valid_reg <= predict_valid;
      predict_index_reg <= predict_index;

      // Capture the PHT entry at predict_index_reg for prediction output next cycle
      // This models synchronous RAM read behavior: read happens at clock edge for the address valid previous cycle
      // However, prediction output must be combinational using current global_history and current PHT entry before update.
      // So we capture predict_pht_entry_reg here as the current PHT entry for the current prediction.
      predict_pht_entry_reg <= pht[predict_index];

      // PHT update due to training
      if (train_valid) begin
        // Update saturating counter for PHT at train_index
        pht[train_index] <= saturating_update(pht[train_index], train_taken);
      end

      // Global history update:
      // Priority:
      // 1) If training and train_mispredicted: restore global_history to train_history
      // 2) Else if prediction valid and no training misprediction override: update global_history with predicted_taken
      // Note predicted_taken_reg is set below
      if (train_valid && train_mispredicted) begin
        global_history <= train_history;
      end else if (predict_valid) begin
        // Update global history with the predicted taken bit (MSB of pht[predict_index])
        // The prediction uses current pht entry before any training update this cycle
        global_history <= {global_history[5:0], pht[predict_index][1]};
      end

      // Update predicted_taken_reg for next cycle global_history update
      // (used for prediction history output consistency)
      predicted_taken_reg <= pht[predict_index][1];
    end
  end

  // Saturating counter update function
  function [1:0] saturating_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        if (counter != 2'b11)
          saturating_update = counter + 1'b1;
        else
          saturating_update = counter;
      end else begin
        if (counter != 2'b00)
          saturating_update = counter - 1'b1;
        else
          saturating_update = counter;
      end
    end
  endfunction

  // Prediction outputs:
  // predict_taken: combinationally from current pht[predict_index] MSB (before update at clock edge)
  // predict_history: current global_history at prediction time (before update)
  assign predict_taken = pht[predict_index][1];
  assign predict_history = global_history;

endmodule