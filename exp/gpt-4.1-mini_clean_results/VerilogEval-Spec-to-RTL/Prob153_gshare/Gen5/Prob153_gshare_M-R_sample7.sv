module TopModule(
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

  // Pattern History Table: 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Registered signals to pipeline prediction read
  reg [6:0] predict_index_reg;      // Registered predict index (PC ^ GHR) at previous cycle
  reg predict_valid_reg;             // Indicates if predict was valid previous cycle
  reg [6:0] ghr_reg;                 // GHR registered to capture history at predict_valid cycle

  // Output data registers
  reg [1:0] predict_counter_reg;    // PHT output corresponding to predict_index_reg

  // Current global history register
  reg [6:0] global_history;

  // Compute indices for current inputs (combinational)
  wire [6:0] predict_index  = predict_pc  ^ global_history;
  wire [6:0] train_index    = train_pc    ^ train_history;

  // Prediction taken signal derived from registered PHT output for previous cycle's predict_index
  wire predicted_taken = predict_counter_reg[1];

  // Outputs (registered to match pipeline)
  assign predict_taken   = predict_valid_reg ? predicted_taken : 1'b0;
  assign predict_history = predict_valid_reg ? ghr_reg : 7'b0;

  // Saturating counter update function
  function [1:0] saturate_update;
    input [1:0] counter;
    input       taken;
    begin
      if (taken) begin
        saturate_update = (counter == 2'b11) ? 2'b11 : counter + 1'b1;
      end else begin
        saturate_update = (counter == 2'b00) ? 2'b00 : counter - 1'b1;
      end
    end
  endfunction

  integer i;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Async reset: initialize PHT and global history
      global_history    <= 7'b0;
      predict_index_reg <= 7'b0;
      predict_valid_reg <= 1'b0;
      ghr_reg           <= 7'b0;
      predict_counter_reg <= 2'b10; // default weakly taken

      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10; // weakly taken
    end else begin
      // ----- PIPELINE PREDICTION READ -----
      // Register prediction inputs for next cycle PHT read and output
      predict_index_reg <= predict_valid ? predict_index : 7'b0;
      predict_valid_reg <= predict_valid;
      ghr_reg           <= global_history; // capture GHR for output when prediction requested

      // Register predict_counter_reg with PHT read at previous cycle's predict_index_reg
      predict_counter_reg <= pht[predict_index_reg];

      // ----- TRAINING UPDATE -----
      if (train_valid) begin
        // Update PHT entry at train_index
        pht[train_index] <= saturate_update(pht[train_index], train_taken);
      end

      // ----- GLOBAL HISTORY UPDATE -----
      // Update GHR with priority:
      // 1) If training and misprediction: restore GHR to train_history
      // 2) Else if training (no misprediction): update GHR by shifting in predicted_taken from previous prediction cycle (if predict_valid_reg)
      // 3) Else if only prediction: update GHR by shifting in predicted_taken from previous prediction cycle (if predict_valid_reg)
      // 4) Else hold GHR

      if (train_valid && train_mispredicted) begin
        // Restore GHR to train_history on misprediction flush
        global_history <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        // Training without misprediction updates GHR if prediction valid last cycle
        if (predict_valid_reg) begin
          global_history <= {global_history[5:0], predicted_taken};
        end
        else begin
          // No valid prediction last cycle, hold GHR
          global_history <= global_history;
        end
      end else if (!train_valid && predict_valid_reg) begin
        // Only prediction valid last cycle, update GHR
        global_history <= {global_history[5:0], predicted_taken};
      end else begin
        // Hold GHR
        global_history <= global_history;
      end
    end
  end

endmodule