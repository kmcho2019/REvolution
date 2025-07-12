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
  reg [1:0] pht [0:127];

  // Global branch history register (7 bits)
  reg [6:0] global_history;

  // Compute indices for prediction and training
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Read PHT entries combinationally for prediction
  wire [1:0] predict_pht_entry = pht[predict_index];

  // Prediction is MSB of the 2-bit saturating counter
  assign predict_taken   = predict_pht_entry[1];
  assign predict_history = global_history;

  // Next global history update value
  reg [6:0] global_history_next;

  // PHT write signals and new value
  reg pht_write_en;
  reg [6:0] pht_write_addr;
  reg [1:0] pht_write_data;

  integer i;

  // Asynchronous reset for PHT and global_history handled in always @(posedge clk or posedge areset)
  // PHT initialization to weakly taken: 2'b10
  // global_history init to 0

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset global history
      global_history <= 7'b0;
      // Reset PHT entries
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10; // weakly taken
      end
    end else begin
      // Update PHT entry if write enabled
      if (pht_write_en)
        pht[pht_write_addr] <= pht_write_data;

      // Update global history
      global_history <= global_history_next;
    end
  end

  // Saturating counter update function (combinational)
  function [1:0] saturating_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        // Increment saturating counter, max 2'b11
        if (counter != 2'b11)
          saturating_update = counter + 1'b1;
        else
          saturating_update = counter;
      end else begin
        // Decrement saturating counter, min 2'b00
        if (counter != 2'b00)
          saturating_update = counter - 1'b1;
        else
          saturating_update = counter;
      end
    end
  endfunction

  // Combinational logic for PHT update and global history update next cycle
  always @* begin
    // Default no PHT write
    pht_write_en   = 1'b0;
    pht_write_addr = 7'b0;
    pht_write_data = 2'b00;
    global_history_next = global_history;

    if (train_valid) begin
      // Training takes precedence over prediction update on global_history

      // Update PHT entry indexed by train_index with train_taken
      pht_write_en   = 1'b1;
      pht_write_addr = train_index;
      pht_write_data = saturating_update(pht[train_index], train_taken);

      if (train_mispredicted) begin
        // Recover global history to train_history on misprediction
        global_history_next = train_history;
      end else begin
        // No misprediction, global history not updated here (prediction update updates global_history on next cycle)
        // But if prediction_valid=1 and no misprediction training, prediction update of global_history applies
        // However if prediction and training happen same cycle, training takes precedence: global_history updated only by training if mispredicted
        if (!(predict_valid && !train_mispredicted)) begin
          // keep global_history_next as train_history (already set above if mispredicted),
          // else no update
        end else begin
          // train_mispredicted==0, so prediction update allowed
          if (predict_valid) begin
            global_history_next = {global_history[5:0], predict_taken};
          end
        end
      end
    end else if (predict_valid) begin
      // Only prediction update if no training this cycle
      global_history_next = {global_history[5:0], predict_taken};
    end
  end

endmodule