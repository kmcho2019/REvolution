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

  // Pattern History Table: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];
  // Global History Register
  reg [6:0] ghr;

  // Compute indices
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [6:0] train_index = train_pc ^ train_history;

  // Read PHT entries for prediction and training
  wire [1:0] predict_counter = pht[predict_index];
  wire [1:0] train_counter = pht[train_index];

  // Prediction: taken if MSB of counter is 1
  wire predict_taken_wire = predict_counter[1];

  // Output assignments
  assign predict_taken = predict_taken_wire;
  assign predict_history = ghr;

  // Saturating counter update function
  function [1:0] update_counter;
    input [1:0] counter;
    input taken;
    begin
      case (counter)
        2'b00: update_counter = taken ? 2'b01 : 2'b00;
        2'b01: update_counter = taken ? 2'b10 : 2'b00;
        2'b10: update_counter = taken ? 2'b11 : 2'b01;
        2'b11: update_counter = taken ? 2'b11 : 2'b10;
        default: update_counter = 2'b10; // default weakly taken
      endcase
    end
  endfunction

  integer i;

  // Asynchronous reset and sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        pht[i] <= 2'b10; // weakly taken
      end
    end else begin
      if (train_valid) begin
        // Update PHT entry for training
        pht[train_index] <= update_counter(pht[train_index], train_taken);
        // If mispredicted, restore GHR to train_history
        if (train_mispredicted) begin
          ghr <= train_history;
        end else if (predict_valid) begin
          // If no misprediction but prediction valid, update GHR with predicted bit
          // Training takes precedence, so only update GHR here if no misprediction
          ghr <= {ghr[5:0], predict_taken_wire};
        end
        // If train_valid but no predict_valid, no GHR update here (keep restored or old)
      end else if (predict_valid) begin
        // No training, just prediction update GHR
        ghr <= {ghr[5:0], predict_taken_wire};
      end
      // else no update to GHR or PHT
    end
  end

endmodule