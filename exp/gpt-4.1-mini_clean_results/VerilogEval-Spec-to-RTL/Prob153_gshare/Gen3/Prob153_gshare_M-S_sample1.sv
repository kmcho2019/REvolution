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

  // Index calculation wires
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Prediction PHT entry read combinationally from pht array
  wire [1:0] predict_pht_entry = pht[predict_index];

  // Predict taken: MSB of saturating counter
  assign predict_taken   = predict_pht_entry[1];
  assign predict_history = global_history;

  // Saturating counter update function
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
  reg [1:0] train_pht_entry_sync;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // Initialize all entries to weakly taken
    end else begin
      if (train_valid) begin
        // Read current PHT entry for train index synchronously
        train_pht_entry_sync <= pht[train_index];

        // Update PHT entry saturating counter based on actual taken
        pht[train_index] <= saturate_update(pht[train_index], train_taken);

        // Update global history
        if (train_mispredicted) begin
          // On mispredict, restore global history to train_history (train priority)
          global_history <= train_history;
        end else begin
          // No mispredict, update with predicted taken if prediction valid
          if (predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
          end
          // else no update to global history
        end
      end else begin
        // No training, update global history if prediction valid
        if (predict_valid) begin
          global_history <= {global_history[5:0], predict_taken};
        end
        // else global_history unchanged
      end
    end
  end

endmodule