module TopModule (
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

  // 2-bit saturating counter states
  // 2'b00 = Strongly Not Taken
  // 2'b01 = Weakly Not Taken
  // 2'b10 = Weakly Taken
  // 2'b11 = Strongly Taken

  reg [1:0] PHT [0:127];
  reg [6:0] ghist;

  wire [6:0] predict_index = predict_pc ^ ghist;
  wire [6:0] train_index   = train_pc ^ train_history;

  // Output: predict_taken and predict_history (history at prediction)
  // Prediction reads PHT with current ghist and predict_pc
  wire [1:0] predict_counter = PHT[predict_index];
  assign predict_taken = (predict_counter[1] == 1'b1);
  assign predict_history = ghist;

  // Next state of saturating counter function
  function [1:0] next_counter;
    input [1:0] counter;
    input       taken;
    begin
      case (counter)
        2'b00: next_counter = taken ? 2'b01 : 2'b00;
        2'b01: next_counter = taken ? 2'b10 : 2'b00;
        2'b10: next_counter = taken ? 2'b11 : 2'b01;
        2'b11: next_counter = taken ? 2'b11 : 2'b10;
        default: next_counter = 2'b10;
      endcase
    end
  endfunction

  integer i;

  // On asynchronous reset, initialize ghist to 0 and PHT entries to weakly taken (2'b10)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghist <= 7'b0;
      for (i=0; i<128; i=i+1) begin
        PHT[i] <= 2'b10; // weakly taken
      end
    end else begin
      // Update PHT if train_valid
      if (train_valid) begin
        // Update saturating counter at train_index with train_taken
        PHT[train_index] <= next_counter(PHT[train_index], train_taken);

        // If mispredicted, recover ghist to train_history
        if (train_mispredicted) begin
          ghist <= train_history;
        end else if (!train_mispredicted && !(predict_valid && train_valid)) begin
          // If training and predicting different entries in the same cycle,
          // and no mispredict, then prediction updates ghist normally.
          // But if train_valid and predict_valid in same cycle with different entries,
          // training has precedence, so skip updating ghist for prediction.
          // So only update ghist on prediction if training not valid or same cycle
          // with no training precedence.
          ghist <= ghist; // no update here because train_valid takes precedence
        end
      end else if (predict_valid) begin
        // If no training this cycle, update ghist by shifting in predicted outcome
        // Prediction updates ghist by inserting predict_taken at LSB
        // Only update ghist if no train_valid (train has precedence)
        ghist <= {ghist[5:0], predict_taken};
      end
    end
  end

endmodule