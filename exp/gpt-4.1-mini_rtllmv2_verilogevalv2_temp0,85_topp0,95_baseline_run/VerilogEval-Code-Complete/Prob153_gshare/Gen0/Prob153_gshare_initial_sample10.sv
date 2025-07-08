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

  // 2-bit saturating counter states:
  // 2'b00: strongly not taken
  // 2'b01: weakly not taken
  // 2'b10: weakly taken
  // 2'b11: strongly taken

  // Pattern History Table (PHT): 128 entries of 2-bit counters
  reg [1:0] PHT [0:127];
  // Global history register
  reg [6:0] global_history;

  // Wires for current prediction index and training index
  wire [6:0] predict_index = predict_pc ^ global_history;
  wire [6:0] train_index = train_pc ^ train_history;

  // Read current saturating counters for prediction and training
  wire [1:0] predict_pht_entry = PHT[predict_index];
  wire [1:0] train_pht_entry = PHT[train_index];

  // Prediction output: taken if MSB of counter is 1
  assign predict_taken = (predict_pht_entry[1] == 1'b1) && predict_valid;
  // Output history used for prediction
  assign predict_history = predict_valid ? global_history : 7'b0;

  integer i;

  // Initialize PHT and global history on async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      global_history <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        PHT[i] <= 2'b10; // weakly taken
      end
    end else begin
      // Update PHT if training valid
      if (train_valid) begin
        // Update saturating counter for train_index
        case (PHT[train_index])
          2'b00: PHT[train_index] <= train_taken ? 2'b01 : 2'b00;
          2'b01: PHT[train_index] <= train_taken ? 2'b10 : 2'b00;
          2'b10: PHT[train_index] <= train_taken ? 2'b11 : 2'b01;
          2'b11: PHT[train_index] <= train_taken ? 2'b11 : 2'b10;
          default: PHT[train_index] <= 2'b10;
        endcase
      end

      // Update global history register
      // Priority: if train_valid and train_mispredicted, restore history to train_history
      // Else if predict_valid, shift in predict_taken
      if (train_valid && train_mispredicted) begin
        global_history <= train_history;
      end else if (predict_valid) begin
        // Shift left by 1 and insert predicted taken bit as LSB
        global_history <= {global_history[5:0], predict_taken};
      end
      // else keep history as is
    end
  end

endmodule