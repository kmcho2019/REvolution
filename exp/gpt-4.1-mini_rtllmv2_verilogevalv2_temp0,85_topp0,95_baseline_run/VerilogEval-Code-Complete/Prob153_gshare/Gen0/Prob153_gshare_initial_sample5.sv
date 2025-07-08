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
  // 2'b00 - strongly not taken
  // 2'b01 - weakly not taken
  // 2'b10 - weakly taken
  // 2'b11 - strongly taken

  // Pattern History Table: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Global History Register (7 bits)
  reg [6:0] ghr;

  // Compute indices for prediction and training
  wire [6:0] predict_idx = predict_pc ^ ghr;
  wire [6:0] train_idx = train_pc ^ train_history;

  // Read current PHT state for prediction index (combinational read)
  wire [1:0] predict_pht_entry = pht[predict_idx];

  // Predict taken if MSB of saturating counter is 1
  assign predict_taken = predict_pht_entry[1];

  // Output the GHR used for this prediction (combinational)
  assign predict_history = ghr;

  integer i;

  // Asynchronous reset and synchronous updates
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset GHR and PHT entries
      ghr <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        // Initialize PHT entries to weakly taken (2'b10)
        pht[i] <= 2'b10;
      end
    end else begin
      // Training update takes precedence if train_valid asserted
      if (train_valid) begin
        // Update PHT entry at train_idx with actual outcome
        case (pht[train_idx])
          2'b00: pht[train_idx] <= train_taken ? 2'b01 : 2'b00;
          2'b01: pht[train_idx] <= train_taken ? 2'b10 : 2'b00;
          2'b10: pht[train_idx] <= train_taken ? 2'b11 : 2'b01;
          2'b11: pht[train_idx] <= train_taken ? 2'b11 : 2'b10;
          default: pht[train_idx] <= 2'b10; // default fallback
        endcase

        // If mispredicted, restore GHR to train_history (recover branch history)
        if (train_mispredicted) begin
          ghr <= train_history;
        end else begin
          // Otherwise update GHR by shifting in actual outcome
          ghr <= {ghr[5:0], train_taken};
        end
      end else if (predict_valid) begin
        // No training or no misprediction, update GHR with predicted bit
        // predicted taken = pht[predict_idx][1]
        ghr <= {ghr[5:0], predict_pht_entry[1]};
      end
      // else no update to GHR or PHT in this cycle
    end
  end

endmodule