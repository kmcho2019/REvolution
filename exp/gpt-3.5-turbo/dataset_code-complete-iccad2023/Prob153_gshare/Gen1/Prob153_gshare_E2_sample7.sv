module gshare_branch_predictor (
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

  parameter INDEX_BITS = 7;
  parameter PHT_SIZE = 128;
  parameter COUNTER_BITS = 2;

  reg [COUNTER_BITS-1:0] pht[PHT_SIZE-1:0];
  reg [6:0] global_history_reg;

  reg [1:0] predict_counter;
  reg [1:0] train_counter;

  always @ (posedge clk or posedge areset) begin
    if (areset) begin
      for (int i = 0; i < PHT_SIZE; i = i + 1) begin
        pht[i] <= 2'b11; // Initialize PHT all to Strongly Taken
      end
      global_history_reg <= 7'b0; // Clear global history register
      predict_counter <= 2'b11; // Initialize predict counter
    end
    else begin
      // Training logic
      if (train_valid) begin
        if (train_mispredicted) begin
          pht[train_pc[INDEX_BITS-1:0]] <= train_counter; // Update PHT
          global_history_reg <= train_history; // Update global history
        end
        train_counter <= (train_taken) ? train_counter + 1 : train_counter - 1; // Update counter
      end

      // Prediction logic
      if (predict_valid) begin
        predict_taken <= predict_counter[1]; // Extract prediction from counter
        predict_history <= global_history_reg; // Output global history
        predict_counter <= pht[{predict_pc, global_history_reg[6:0]}]; // Update predict counter
      end
    end
  end

endmodule