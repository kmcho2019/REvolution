module TopModule (
  input        clk,
  input        areset,

  input        predict_valid,
  input  [6:0] predict_pc,
  output       predict_taken,
  output [6:0] predict_history,

  input        train_valid,
  input        train_taken,
  input        train_mispredicted,
  input  [6:0] train_history,
  input  [6:0] train_pc
);

  // Parameters
  localparam PHT_SIZE = 128; // 2^7
  localparam COUNTER_WIDTH = 2;

  // Pattern History Table: 2-bit saturating counters
  reg [1:0] pht [0:PHT_SIZE-1];

  // Global branch history register (7 bits)
  reg [6:0] global_history;

  // Compute index for prediction: XOR of pc and global history
  wire [6:0] predict_index = predict_pc ^ global_history;

  // Compute index for training: XOR of train_pc and train_history
  wire [6:0] train_index = train_pc ^ train_history;

  // Read PHT entry for prediction (combinational)
  wire [1:0] predict_counter = pht[predict_index];

  // Prediction is taken if MSB of counter is 1
  assign predict_taken = predict_counter[1];
  assign predict_history = global_history;

  // Helper functions for saturating counter update
  function [1:0] counter_update;
    input [1:0] counter;
    input       taken;
    begin
      case (counter)
        2'b00: counter_update = taken ? 2'b01 : 2'b00; // strongly not taken
        2'b01: counter_update = taken ? 2'b10 : 2'b00; // weakly not taken
        2'b10: counter_update = taken ? 2'b11 : 2'b01; // weakly taken
        2'b11: counter_update = taken ? 2'b11 : 2'b10; // strongly taken
        default: counter_update = 2'b01; // default weakly not taken
      endcase
    end
  endfunction

  integer i;

  // Initialize PHT and history asynchronously
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < PHT_SIZE; i = i + 1) begin
        pht[i] <= 2'b01; // weakly not taken at reset
      end
    end else begin
      // Training update to PHT
      if (train_valid) begin
        pht[train_index] <= counter_update(pht[train_index], train_taken);
      end

      // Global history register update logic:
      // If train_valid && train_mispredicted: recover history to train_history
      // else if train_valid (not mispredicted): update history with actual outcome
      // else if predict_valid: update history with predicted outcome
      // Train takes precedence if train_valid && predict_valid

      if (train_valid) begin
        if (train_mispredicted) begin
          global_history <= train_history;
        end else begin
          // Update history with actual branch outcome
          global_history <= {global_history[5:0], train_taken};
        end
      end else if (predict_valid) begin
        // Update history with predicted branch outcome
        global_history <= {global_history[5:0], predict_taken};
      end
      // else no update to history
    end
  end

endmodule