module GShareBranchPredictor (
  input clk,
  input areset,

  input predict_valid,
  input [6:0] predict_pc,
  output predict_taken,
  output [6:0] predict_history,

  input train_valid,
  input train_taken,
  input train_mispredicted,
  input [6:0] train_history,
  input [6:0] train_pc
);

  /* Define parameters */
  parameter PHT_SIZE = 128;
  parameter COMBINED_PC_WIDTH = 7;
  parameter GLOBAL_HISTORY_WIDTH = 7;
  
  /* Define signals */
  reg [1:0] pattern_history_table [0:PHT_SIZE-1]; // 128-entry table of 2-bit saturating counters
  reg [6:0] global_history_register = 7'b0;
  
  /* Prediction logic */
  always @(posedge clk) begin
    if (areset) begin
      // Reset logic
      global_history_register <= 7'b0;
    end else begin
      if (predict_valid) begin
        // Calculate index using XOR of pc and global history
        reg [6:0] index = {global_history_register, predict_pc} ^ (GLOBAL_HISTORY_WIDTH - 1);
        
        // Predict taken/not taken based on the state of the saturating counter
        predict_taken <= (pattern_history_table[index] > 1);
        predict_history <= global_history_register;
      end
    end
  end

  /* Training logic */
  always @(posedge clk) begin
    if (areset) begin
      // Reset logic
      global_history_register <= 7'b0;
    end else begin
      if (train_valid) begin
        // Calculate index using XOR of pc and global history
        reg [6:0] index = {train_history, train_pc} ^ (GLOBAL_HISTORY_WIDTH - 1);
        
        // Update pattern history table
        if (train_mispredicted) begin
          // Recover branch history register
          global_history_register <= train_history;
        }
        
        // Update saturating counter based on actual branch outcome
        if (train_taken) begin
          if (pattern_history_table[index] < 3) begin
            pattern_history_table[index] <= pattern_history_table[index] + 1;
          end
        end else begin
          if (pattern_history_table[index] > 0) begin
            pattern_history_table[index] <= pattern_history_table[index] - 1;
          end
        end
      end
    end
  end

endmodule