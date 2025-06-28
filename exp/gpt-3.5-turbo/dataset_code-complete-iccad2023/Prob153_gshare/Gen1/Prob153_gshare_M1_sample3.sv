module gshare_predictor (
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

  reg [1:0] pht[PHT_SIZE-1:0];
  reg [6:0] global_history_reg;
  reg update_flag;

  wire [INDEX_BITS-1:0] index = predict_pc ^ global_history_reg;

  // Prediction block
  always @* begin
    if (predict_valid) begin
      predict_taken = pht[index];
      predict_history = global_history_reg;
    end
  end

  // Training block
  always @* begin
    if (train_valid && !update_flag) begin
      pht[index] = (train_taken && pht[index] < 3) ? pht[index] + 1 :
                   (!train_taken && pht[index] > 0) ? pht[index] - 1 : pht[index];
      global_history_reg = train_history;
      if (train_mispredicted) begin
        global_history_reg = {global_history_reg[5:0], train_taken};
        update_flag = 1;
      end
    end
  end

  // Clocked block for updating prediction registers
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      pht <= 0;
      global_history_reg <= 0;
    end
    else begin
      if (predict_valid && !train_valid) begin
        pht[index] <= predict_taken;
        global_history_reg <= {global_history_reg[5:0], predict_taken};
      end
      else if (update_flag) begin
        global_history_reg <= {global_history_reg[5:0], train_taken};
        update_flag = 0;
      end
    end
  end

endmodule