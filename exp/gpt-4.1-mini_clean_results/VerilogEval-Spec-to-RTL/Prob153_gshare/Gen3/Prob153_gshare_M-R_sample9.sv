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

  // Index calculations
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index   = train_pc ^ train_history;

  // PHT read output registers
  reg [1:0] pht_predict_entry_q;
  reg [1:0] pht_train_entry_q;

  integer i;

  // Asynchronous reset and PHT initialization
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // weakly taken (standard reset state)
      pht_predict_entry_q <= 2'b10;
      pht_train_entry_q   <= 2'b10;
    end else begin
      // Register PHT read for prediction and training indices for next cycle use
      pht_predict_entry_q <= pht[predict_index];
      pht_train_entry_q   <= pht[train_index];

      // Training update
      if (train_valid) begin
        // Update the saturating counter at train_index using registered old value
        pht[train_index] <= saturate_update(pht_train_entry_q, train_taken);

        // Global history update precedence
        if (train_mispredicted) begin
          // On misprediction, restore global history to training history (discard predicted update)
          global_history <= train_history;
        end else begin
          // No misprediction
          if (predict_valid) begin
            global_history <= {global_history[5:0], pht_predict_entry_q[1]};
          end
          // else no prediction valid: keep global_history unchanged
        end
      end else begin
        // No training this cycle
        if (predict_valid) begin
          global_history <= {global_history[5:0], pht_predict_entry_q[1]};
        end
        // else keep global_history unchanged
      end
    end
  end

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

  // Prediction outputs are combinational from registered PHT read and global_history
  // This matches the timing: prediction outputs reflect PHT and history state at the current cycle before update
  assign predict_taken   = pht_predict_entry_q[1];
  assign predict_history = global_history;

endmodule