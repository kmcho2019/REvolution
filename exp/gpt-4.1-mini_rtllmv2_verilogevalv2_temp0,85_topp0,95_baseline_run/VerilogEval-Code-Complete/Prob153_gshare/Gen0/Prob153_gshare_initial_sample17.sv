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
  // States: 2'b00 = Strongly Not Taken, 2'b01 = Weakly Not Taken
  //         2'b10 = Weakly Taken,     2'b11 = Strongly Taken
  reg [1:0] pht [0:127];

  // Global history register (7 bits)
  reg [6:0] ghr;

  // Compute indices
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [6:0] train_index = train_pc ^ train_history;

  // Read current PHT entries combinationally
  wire [1:0] predict_pht_entry = pht[predict_index];
  wire [1:0] train_pht_entry = pht[train_index];

  // Prediction: taken if MSB of counter is 1
  wire predict_taken_raw = predict_pht_entry[1];

  assign predict_taken = (predict_valid) ? predict_taken_raw : 1'b0;
  // Output the ghr at prediction time (before update)
  assign predict_history = (predict_valid) ? ghr : 7'b0;

  // Next value for ghr if prediction updates it
  wire [6:0] ghr_pred_next = {ghr[5:0], predict_taken_raw};

  // Next value for ghr if training updates it (restore to train_history if mispredicted)
  wire [6:0] ghr_train_next = train_mispredicted ? train_history : ghr;

  // Saturating counter update function
  function [1:0] satctr_update;
    input [1:0] state;
    input taken;
    begin
      case (state)
        2'b00: satctr_update = taken ? 2'b01 : 2'b00;
        2'b01: satctr_update = taken ? 2'b10 : 2'b00;
        2'b10: satctr_update = taken ? 2'b11 : 2'b01;
        2'b11: satctr_update = taken ? 2'b11 : 2'b10;
        default: satctr_update = 2'b10; // default weakly taken
      endcase
    end
  endfunction

  integer i;
  // Synchronous logic: update ghr and PHT on posedge clk or async reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'b0;
      for (i=0; i<128; i=i+1)
        pht[i] <= 2'b10; // Initialize PHT to weakly taken
    end else begin
      // Update PHT if training valid
      if (train_valid) begin
        pht[train_index] <= satctr_update(train_pht_entry, train_taken);
      end
      // Update ghr: training takes precedence if train_valid
      if (train_valid) begin
        if (train_mispredicted) begin
          // Recover ghr to train_history after mispredicted branch
          ghr <= train_history;
        end else begin
          // Update ghr with predicted outcome of train branch (train_taken)
          // Only update if train_mispredicted=0 (normal training)
          ghr <= {train_history[5:0], train_taken};
          // Note: train_history is the GHR *after* the branch was executed,
          // so we shift in train_taken to reflect the most recent branch
        end
      end else if (predict_valid) begin
        // No training or no misprediction: update ghr with predicted outcome
        ghr <= ghr_pred_next;
      end
      // else keep ghr unchanged
    end
  end
endmodule