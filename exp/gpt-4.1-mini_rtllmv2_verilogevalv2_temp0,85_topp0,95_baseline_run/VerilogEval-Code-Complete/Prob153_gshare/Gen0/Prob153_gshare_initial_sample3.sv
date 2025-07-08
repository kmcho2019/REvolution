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

  // Pattern History Table: 128 entries, 2-bit saturating counters
  reg [1:0] PHT [0:127];

  // Global History Register (GHR)
  reg [6:0] GHR;

  // Compute index for prediction: XOR PC and GHR
  wire [6:0] predict_index = predict_pc ^ GHR;

  // Prediction counter read (combinational)
  wire [1:0] predict_counter = PHT[predict_index];

  // Output predicted taken: MSB of counter (2-bit saturating counter: 2 or 3 = taken)
  assign predict_taken = predict_counter[1];

  // Output the GHR used for prediction (before update)
  assign predict_history = GHR;

  // Compute index for training: XOR train_pc and train_history
  wire [6:0] train_index = train_pc ^ train_history;

  // Saturating counter update function for training
  function [1:0] update_counter;
    input [1:0] old;
    input taken;
    begin
      case (old)
        2'b00: update_counter = taken ? 2'b01 : 2'b00;
        2'b01: update_counter = taken ? 2'b10 : 2'b00;
        2'b10: update_counter = taken ? 2'b11 : 2'b01;
        2'b11: update_counter = taken ? 2'b11 : 2'b10;
        default: update_counter = 2'b01;
      endcase
    end
  endfunction

  // Next GHR for prediction: shift left and insert predicted taken bit
  wire [6:0] GHR_next_pred = {GHR[5:0], predict_taken};

  // Next GHR for training recovery (if mispredicted)
  wire [6:0] GHR_next_train = train_history;

  // Control signals for GHR update:
  // If train_valid & train_mispredicted: use train_history for GHR (recover)
  // Else if predict_valid: update GHR speculatively with predicted taken
  // Else keep GHR as is.

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      GHR <= 7'b0;
    end else begin
      if (train_valid && train_mispredicted) begin
        // Training recovery overrides speculative update
        GHR <= GHR_next_train;
      end else if (predict_valid) begin
        GHR <= GHR_next_pred;
      end
      // else keep GHR
    end
  end

  // PHT update on training at clock edge
  always @(posedge clk or posedge areset) begin
    integer i;
    if (areset) begin
      // Initialize PHT entries to weakly not taken (01)
      for (i = 0; i < 128; i = i + 1) begin
        PHT[i] <= 2'b01;
      end
    end else begin
      if (train_valid) begin
        PHT[train_index] <= update_counter(PHT[train_index], train_taken);
      end
    end
  end

endmodule