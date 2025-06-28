module TopModule (
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

  // Constants
  parameter INDEX_WIDTH = 7;
  parameter HISTORY_WIDTH = 7;
  parameter PHT_SIZE = 128;
  parameter COUNTER_WIDTH = 2;
  
  // Branch Predictor components
  reg [COUNTER_WIDTH-1:0] pht[PHT_SIZE-1:0];
  reg [HISTORY_WIDTH-1:0] global_history;

  // Branch Predictor internal signals
  reg predicted_taken;
  reg [HISTORY_WIDTH-1:0] predicted_history;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset the branch predictor components
      global_history <= 0;
      for (int i = 0; i < PHT_SIZE; i = i+1) begin
        pht[i] <= 0;
      end
    end
    else begin
      // Prediction Logic
      if (predict_valid) begin
         // Compute the PHT index using global history and pc
         reg [INDEX_WIDTH-1:0] index = (predict_pc ^ global_history) % PHT_SIZE;

         predicted_taken <= pht[index] >= 2;
         predicted_history <= global_history;
      end

      // Training Logic
      if (train_valid) begin
        // Compute the PHT index using train_history and pc
        reg [INDEX_WIDTH-1:0] index = (train_pc ^ train_history) % PHT_SIZE;

        if (train_mispredicted) begin
          // Reset the PHT entry if misprediction
          pht[index] <= (pht[index] == 0) ? 0 : pht[index] - 1;
        else begin
          // Update the PHT entry based on actual outcome
          pht[index] <= (train_taken) ? 
                        ((pht[index] < 3) ? pht[index] + 1 : pht[index]) :
                        ((pht[index] > 0) ? pht[index] - 1 : pht[index]);
        end

        // Update the global history register
        global_history <= {global_history[HISTORY_WIDTH-2:0], train_taken};
      end
    end
  end

  // Output assignment
  assign predict_taken = predicted_taken;
  assign predict_history = predicted_history;
  
endmodule