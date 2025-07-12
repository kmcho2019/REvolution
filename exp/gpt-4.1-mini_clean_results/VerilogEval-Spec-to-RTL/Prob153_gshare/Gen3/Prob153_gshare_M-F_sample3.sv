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
  reg [6:0] global_history;

  // Indices
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Prediction read (combinational)
  wire [1:0] predict_pht_entry = pht[predict_index];

  // Prediction outputs
  assign predict_taken   = predict_pht_entry[1];
  assign predict_history = global_history;

  // Saturating counter update function
  function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken)
        saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1'b1;
      else
        saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1'b1;
    end
  endfunction

  // Register to hold the train PHT entry read on clock (to avoid combinational read)
  reg [1:0] train_pht_entry_q;

  integer i;

  // Read train PHT entry synchronously (one cycle delayed)
  always @(posedge clk) begin
    if (areset) begin
      train_pht_entry_q <= 2'b10; // default weakly taken on reset
    end else if (train_valid) begin
      train_pht_entry_q <= pht[train_index];
    end
  end

  // PHT and global_history update
  always @(posedge clk) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // weakly taken
    end else begin
      if (train_valid) begin
        // Update PHT entry indexed by train_index with previous read counter
        pht[train_index] <= saturate_update(train_pht_entry_q, train_taken);

        if (train_mispredicted) begin
          // Restore global_history to train_history on misprediction (training takes precedence)
          global_history <= train_history;
        end else begin
          // No misprediction: update global_history with predicted taken if prediction valid
          if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
          end
          // else no update
        end
      end else begin
        // No training this cycle: update global_history with predicted taken if prediction valid
        if (predict_valid) begin
          global_history <= {global_history[5:0], predict_taken};
        end
        // else no update
      end
    end
  end

endmodule