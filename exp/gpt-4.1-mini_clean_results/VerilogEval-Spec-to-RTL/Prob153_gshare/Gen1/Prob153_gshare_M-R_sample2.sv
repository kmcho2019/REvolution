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

  // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
  // Implement as a reg array with synchronous read (register indexed)
  reg [1:0] pht [0:127];

  // Register holding PHT entry read for prediction (to stabilize outputs)
  reg [1:0] predict_pht_entry_reg;

  // Global branch history register (7 bits)
  reg [6:0] global_history;

  // Indices for prediction and training
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Next state signals
  reg [1:0] pht_entry_read; // to latch pht[predict_index] synchronously for stable output

  // Saturating counter update function (pure combinational)
  function [1:0] saturating_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        saturating_update = (counter == 2'b11) ? 2'b11 : (counter + 1'b1);
      end else begin
        saturating_update = (counter == 2'b00) ? 2'b00 : (counter - 1'b1);
      end
    end
  endfunction

  // Prediction outputs come from the last read of the PHT entry and the global_history before update
  assign predict_taken   = predict_pht_entry_reg[1];
  assign predict_history = global_history;

  // Sequential logic: synchronous reads and writes, async reset
  integer i;
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'd0;
      predict_pht_entry_reg <= 2'b10; // default weakly taken
      // Initialize PHT entries to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10;
      end
    end else begin
      // Synchronously read PHT entry at predict_index for prediction outputs in next cycle
      // Because reading pht asynchronously in combinational leads to race conditions,
      // read here and store in predict_pht_entry_reg
      predict_pht_entry_reg <= pht[predict_index];

      // PHT update on training, if train_valid asserted
      if (train_valid) begin
        pht[train_index] <= saturating_update(pht[train_index], train_taken);
      end

      // Update global history with training precedence
      if (train_valid && train_mispredicted) begin
        // Recover global history on misprediction
        global_history <= train_history;
      end else if (predict_valid && !(train_valid && train_mispredicted)) begin
        // Shift in predicted taken bit from PHT entry read last cycle (predict_pht_entry_reg)
        // This aligns with the spec: use prediction valid, but training mispredict blocks update
        // Use predict_taken derived from predict_pht_entry_reg
        global_history <= {global_history[5:0], predict_pht_entry_reg[1]};
      end else begin
        // Hold global_history
        global_history <= global_history;
      end
    end
  end

endmodule