module BranchPredictor (
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

  reg [6:0] global_history = 7'b0;
  reg [6:0] pht_index;
  reg [1:0] pht[0:127]; // Two-bit saturating counters for each entry in PHT

  always@(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      pht <= 128'h0000; // Initializing PHT to Strongly Not Taken
    end else begin
      // Update branch history
      if (predict_valid) begin
        pht_index = (global_history ^ predict_pc) & 7'h7F; // Hash pc with global history
        predict_history <= global_history;
        predict_taken <= (pht[pht_index] >= 2);
      end

      // Training the branch predictor
      if (train_valid) begin
        pht_index = (train_history ^ train_pc) & 7'h7F;
        if (train_mispredicted) begin
          global_history <= train_history;
        end
        if (train_taken) begin
          if (pht[pht_index] < 3) // If not Strongly Taken, increment counter
            pht[pht_index] <= pht[pht_index] + 1;
        else // Otherwise, do nothing if Strongly Taken
          pht[pht_index] <= 3; // Set to Strongly Taken
        end else begin
          if (pht[pht_index] > 0) // If not Strongly Not Taken, decrement counter
            pht[pht_index] <= pht[pht_index] - 1;
        else // Otherwise, do nothing if Strongly Not Taken
          pht[pht_index] <= 0; // Set to Strongly Not Taken
        end
      end
    end
  end
endmodule