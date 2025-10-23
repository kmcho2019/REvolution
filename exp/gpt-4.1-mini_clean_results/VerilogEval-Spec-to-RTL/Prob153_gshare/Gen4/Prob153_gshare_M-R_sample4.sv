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

  // Combinational reads from PHT for current cycle
  wire [1:0] pht_predict_entry = pht[predict_index];
  wire [1:0] pht_train_entry   = pht[train_index];

  integer i;

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

  // Sequential logic for PHT updates and global history update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10; // weakly taken on reset
      end
    end else begin
      // Training update
      if (train_valid) begin
        // Update saturating counter at train_index based on current PHT value and train_taken
        pht[train_index] <= saturate_update(pht_train_entry, train_taken);

        // Global history update priority
        if (train_mispredicted) begin
          // Restore global history to train_history on mispredict
          global_history <= train_history;
        end else begin
          // No mispredict, update global history if prediction valid
          if (predict_valid) begin
            // Append predict_taken bit (MSB of pht_predict_entry)
            global_history <= {global_history[5:0], pht_predict_entry[1]};
          end
          // else keep global_history unchanged
        end
      end else begin
        // No training, update global history if prediction valid
        if (predict_valid) begin
          global_history <= {global_history[5:0], pht_predict_entry[1]};
        end
        // else keep global_history unchanged
      end
    end
  end

  // Combinational prediction outputs (reflect current PHT and global history state before update)
  assign predict_taken   = pht_predict_entry[1];
  assign predict_history = global_history;

endmodule