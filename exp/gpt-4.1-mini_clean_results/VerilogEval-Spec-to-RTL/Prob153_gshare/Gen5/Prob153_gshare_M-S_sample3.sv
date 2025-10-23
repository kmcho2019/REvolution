module TopModule(
  input         clk,
  input         areset,

  input         predict_valid,
  input  [6:0]  predict_pc,
  output reg    predict_taken,
  output reg [6:0] predict_history,

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

  // Pipeline registers to hold prediction inputs and outputs (to align with synchronous RAM read)
  reg        predict_valid_r;
  reg  [6:0] predict_pc_r;
  reg  [6:0] predict_index_r;
  reg  [1:0] predict_counter_r;

  // Saturating counter update function
  function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1'b1;
      else        saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1'b1;
    end
  endfunction

  integer i;

  // On clock edge, latch prediction index and PHT counter (synchronous RAM read)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_valid_r   <= 1'b0;
      predict_pc_r      <= 7'b0;
      predict_index_r   <= 7'b0;
      predict_counter_r <= 2'b10; // default weakly taken
    end else begin
      predict_valid_r <= predict_valid;
      predict_pc_r    <= predict_pc;
      predict_index_r <= predict_pc ^ global_history;
      predict_counter_r <= pht[predict_pc ^ global_history];
    end
  end

  // Output prediction signals reflect the registered prediction outputs (from previous cycle)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      predict_taken   <= 1'b0;
      predict_history <= 7'b0;
    end else begin
      if (predict_valid_r) begin
        predict_taken   <= predict_counter_r[1]; // MSB is prediction
        predict_history <= global_history;
      end else begin
        predict_taken   <= 1'b0;
        predict_history <= global_history;
      end
    end
  end

  // Train index and current counter for update
  wire [6:0] train_index = train_pc ^ train_history;
  reg  [1:0] train_counter;

  // Read train_counter synchronously (from PHT at train_index)
  // Because we only write on posedge clk, we must register train_index to access PHT
  reg [6:0] train_index_r;
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      train_index_r <= 7'b0;
      train_counter <= 2'b10;
    end else begin
      train_index_r <= train_index;
      train_counter <= pht[train_index];
    end
  end

  // Main sequential logic: update PHT and GHR
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10; // weakly taken
      end
    end else begin
      // Update PHT entry if training valid
      if (train_valid) begin
        pht[train_index] <= saturate_update(pht[train_index], train_taken);
      end

      // Update global_history with priority:
      // 1. If training valid and mispredicted: restore global_history to train_history (flush)
      // 2. Else if training valid and no misprediction: update global_history with previous cycle's prediction taken if that prediction was valid
      // 3. Else if no training but previous prediction valid: update global_history with previous cycle's prediction taken
      // 4. Else keep global_history unchanged

      if (train_valid && train_mispredicted) begin
        global_history <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        if (predict_valid_r) begin
          global_history <= {global_history[5:0], predict_counter_r[1]};
        end
        // else no update to global_history
      end else if (!train_valid && predict_valid_r) begin
        global_history <= {global_history[5:0], predict_counter_r[1]};
      end
      // else global_history remains unchanged
    end
  end

endmodule