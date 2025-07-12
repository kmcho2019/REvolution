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

  // Pattern History Table (PHT): 128 entries of 2-bit saturating counters
  reg [1:0] pht [0:127];

  // Global History Register (GHR)
  reg [6:0] ghr;

  // Pipeline stage 1 registers: register prediction requests and capture GHR used for indexing
  reg          predict_valid_s1;
  reg  [6:0]   predict_pc_s1;
  reg  [6:0]   predict_index_s1;
  reg  [6:0]   predict_ghr_used_s1; // GHR used for prediction index (captured before update)

  // Pipeline stage 2 registers: register PHT read data and prediction metadata for output
  reg          predict_valid_s2;
  reg  [6:0]   predict_pc_s2;
  reg  [6:0]   predict_index_s2;
  reg  [1:0]   predict_counter_s2;
  reg  [6:0]   predict_ghr_used_s2;

  // Compute prediction index combinationally: xor pc with current GHR
  wire [6:0] predict_index_curr = predict_pc ^ ghr;

  // Compute training index combinationally: xor train_pc with train_history
  wire [6:0] train_index = train_pc ^ train_history;

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

  // Sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset PHT to weakly taken (2'b10)
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b10;

      // Reset GHR to zero
      ghr <= 7'b0;

      // Clear pipeline registers
      predict_valid_s1    <= 1'b0;
      predict_pc_s1       <= 7'b0;
      predict_index_s1    <= 7'b0;
      predict_ghr_used_s1 <= 7'b0;

      predict_valid_s2    <= 1'b0;
      predict_pc_s2       <= 7'b0;
      predict_index_s2    <= 7'b0;
      predict_counter_s2  <= 2'b10; // weakly taken
      predict_ghr_used_s2 <= 7'b0;

    end else begin
      // ========== Prediction pipeline stage 1 ==========
      // Latch prediction request signals and capture GHR used for index before update
      predict_valid_s1    <= predict_valid;
      predict_pc_s1       <= predict_pc;
      predict_index_s1    <= predict_valid ? predict_index_curr : 7'b0;
      predict_ghr_used_s1 <= ghr;

      // ========== Prediction pipeline stage 2 ==========
      predict_valid_s2    <= predict_valid_s1;
      predict_pc_s2       <= predict_pc_s1;
      predict_index_s2    <= predict_index_s1;
      predict_ghr_used_s2 <= predict_ghr_used_s1;

      // Synchronous read of PHT entry for stage 1 index, available next cycle
      predict_counter_s2  <= pht[predict_index_s1];

      // ========== Training update ==========
      if (train_valid) begin
        // Update saturating counter for training index
        pht[train_index] <= saturate_update(pht[train_index], train_taken);
      end

      // ========== GHR update ==========
      // Priority per problem statement:
      // 1) If train_valid & train_mispredicted: restore GHR to train_history (flush)
      // 2) Else if train_valid & !train_mispredicted: shift in actual outcome (train_taken)
      // 3) Else if predict_valid_s2: shift in predicted taken bit from PHT output
      // 4) Else hold GHR

      if (train_valid && train_mispredicted) begin
        ghr <= train_history;
      end else if (train_valid && !train_mispredicted) begin
        ghr <= {ghr[5:0], train_taken};
      end else if (predict_valid_s2) begin
        ghr <= {ghr[5:0], predict_counter_s2[1]};
      end else begin
        ghr <= ghr; // hold
      end
    end
  end

  // Output assignment
  assign predict_taken   = predict_valid_s2 ? predict_counter_s2[1] : 1'b0;
  assign predict_history = predict_valid_s2 ? predict_ghr_used_s2   : 7'b0;

endmodule