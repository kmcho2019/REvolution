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

  // Pattern History Table (PHT) of 128 2-bit saturating counters
  // 2'b00 = strongly not taken, 2'b01 = weakly not taken
  // 2'b10 = weakly taken, 2'b11 = strongly taken
  reg [1:0] pht [0:127];

  // Global History Register (GHR), 7 bits
  reg [6:0] ghr;

  // Compute prediction index = PC XOR GHR (for prediction)
  wire [6:0] predict_index = predict_pc ^ ghr;

  // Prediction output counter (read PHT at predict_index)
  wire [1:0] predict_counter = pht[predict_index];
  wire predict_dir = predict_counter[1]; // MSB is prediction bit

  assign predict_taken = predict_valid ? predict_dir : 1'b0;
  assign predict_history = ghr;

  // Compute training index = train_pc XOR train_history
  wire [6:0] train_index = train_pc ^ train_history;
  reg [1:0] train_counter_old;

  // Read PHT entry for training index (combinational)
  always @(*) begin
    train_counter_old = pht[train_index];
  end

  // Next state of PHT counter for training update
  function [1:0] saturate_update;
    input [1:0] counter;
    input taken;
    begin
      if (taken) begin
        // increment saturating
        case (counter)
          2'b00: saturate_update = 2'b01;
          2'b01: saturate_update = 2'b10;
          2'b10: saturate_update = 2'b11;
          2'b11: saturate_update = 2'b11;
          default: saturate_update = 2'b01;
        endcase
      end else begin
        // decrement saturating
        case (counter)
          2'b00: saturate_update = 2'b00;
          2'b01: saturate_update = 2'b00;
          2'b10: saturate_update = 2'b01;
          2'b11: saturate_update = 2'b10;
          default: saturate_update = 2'b01;
        endcase
      end
    end
  endfunction

  // Next PHT write data and address, valid for update
  reg pht_write_en;
  reg [6:0] pht_write_addr;
  reg [1:0] pht_write_data;

  integer i;

  // Update logic for PHT and GHR at positive clock edge or async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'd0;
      for (i = 0; i < 128; i = i + 1) begin
        // Initialize PHT entries to weakly taken (2'b01)
        pht[i] <= 2'b01;
      end
    end else begin
      // Update PHT if training valid
      if (train_valid) begin
        pht[train_index] <= saturate_update(train_counter_old, train_taken);
      end

      // Update GHR at clock edge:
      // If training valid and mispredicted, restore GHR to train_history
      // Else if predict_valid and no misprediction training at same cycle, update GHR with predicted bit
      if (train_valid && train_mispredicted) begin
        ghr <= train_history;
      end else if (predict_valid && !(train_valid && train_mispredicted)) begin
        // Update GHR with predicted taken bit shifted in (MSB dropped)
        ghr <= {ghr[5:0], predict_dir};
      end
      // else no update to GHR
    end
  end

endmodule