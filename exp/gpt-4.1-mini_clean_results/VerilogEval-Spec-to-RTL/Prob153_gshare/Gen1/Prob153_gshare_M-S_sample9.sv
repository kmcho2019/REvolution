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

  // PHT: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];
  reg [6:0] global_history;

  // Indices for prediction and training
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Read PHT entries for prediction
  wire [1:0] predict_pht_entry = pht[predict_index];

  // Prediction is MSB of the saturating counter
  assign predict_taken = predict_pht_entry[1];
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

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10;  // weakly taken
    end else begin
      // Update PHT and global_history with priority to training
      if (train_valid) begin
        // Update the PHT entry indexed by train_index
        pht[train_index] <= saturate_update(pht[train_index], train_taken);

        // On misprediction, restore global_history to train_history
        if (train_mispredicted) begin
          global_history <= train_history;
        end else begin
          // No misprediction: global history updated only by prediction if valid and no misprediction training in this cycle
          if (!train_mispredicted && predict_valid) begin
            global_history <= {global_history[5:0], predict_taken};
          end
          else if (!predict_valid) begin
            // No prediction update, keep history
            global_history <= global_history;
          end
        end
      end else begin
        // No training this cycle
        if (predict_valid) begin
          global_history <= {global_history[5:0], predict_taken};
        end
      end
    end
  end

endmodule