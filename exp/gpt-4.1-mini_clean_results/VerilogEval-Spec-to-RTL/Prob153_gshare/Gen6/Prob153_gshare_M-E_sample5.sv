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
  reg [1:0] pht [0:127];

  // Global History Register (GHR)
  reg [6:0] ghr;

  // Prediction pipeline registers (stage 0: prediction request)
  reg          predict_valid_d1;
  reg  [6:0]   predict_pc_d1;
  reg  [6:0]   predict_index_d1;

  // Prediction pipeline registers (stage 1: synchronous PHT read data)
  reg          predict_valid_d2;
  reg  [6:0]   predict_pc_d2;
  reg  [6:0]   predict_index_d2;
  reg  [1:0]   predict_counter_d2;
  reg  [6:0]   predict_history_d2;

  // Compute index for current prediction request (combinational)
  wire [6:0] predict_index_curr = predict_pc ^ ghr;

  // Compute index for training update (combinational)
  wire [6:0] train_index = train_pc ^ train_history;

  // Saturating counter update function
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

  // Asynchronous reset and synchronous updates
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset PHT to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10;
      end
      // Reset GHR to zero
      ghr <= 7'b0;

      // Reset prediction pipeline registers
      predict_valid_d1 <= 1'b0;
      predict_pc_d1    <= 7'b0;
      predict_index_d1 <= 7'b0;

      predict_valid_d2 <= 1'b0;
      predict_pc_d2    <= 7'b0;
      predict_index_d2 <= 7'b0;
      predict_counter_d2 <= 2'b10;  // weakly taken default
      predict_history_d2 <= 7'b0;
    end else begin
      // === Prediction pipeline stage 0 ===
      predict_valid_d1 <= predict_valid;
      predict_pc_d1    <= predict_pc;
      // If prediction is valid, compute index as pc ^ current GHR
      // Else hold last value (safe to zero but irrelevant if invalid)
      predict_index_d1 <= predict_valid ? predict_index_curr : 7'b0;

      // === Prediction pipeline stage 1 ===
      predict_valid_d2 <= predict_valid_d1;
      predict_pc_d2    <= predict_pc_d1;
      predict_index_d2 <= predict_index_d1;
      predict_history_d2 <= ghr;  // Capture GHR at prediction request cycle

      // Read PHT entry for previous cycle's prediction index (synchronous read)
      predict_counter_d2 <= pht[predict_index_d1];

      // === Training update ===
      if (train_valid) begin
        // Update saturating counter for train_index
        pht[train_index] <= saturate_update(pht[train_index], train_taken);
      end

      // === GHR update ===
      // Priority:
      // 1) If training and mispredicted -> recover GHR to train_history
      // 2) Else if training (no mispredicted) -> update GHR by shifting in previous prediction taken bit if valid
      // 3) Else if only previous cycle prediction valid -> update GHR by shifting in previous prediction taken bit
      // 4) Else hold GHR

      if (train_valid && train_mispredicted) begin
        // Restore GHR to train_history on misprediction flush
        ghr <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        // Update GHR by shifting in previous prediction taken bit only if prediction was valid
        if (predict_valid_d2) begin
          ghr <= {ghr[5:0], predict_counter_d2[1]};
        end else begin
          ghr <= ghr; // hold if no valid prediction
        end
      end else if (!train_valid && predict_valid_d2) begin
        // No training, update GHR by previous prediction taken bit
        ghr <= {ghr[5:0], predict_counter_d2[1]};
      end else begin
        // Hold GHR
        ghr <= ghr;
      end
    end
  end

  // Outputs are from prediction pipeline stage 1
  assign predict_taken   = predict_valid_d2 ? predict_counter_d2[1] : 1'b0;
  assign predict_history = predict_valid_d2 ? predict_history_d2   : 7'b0;

endmodule