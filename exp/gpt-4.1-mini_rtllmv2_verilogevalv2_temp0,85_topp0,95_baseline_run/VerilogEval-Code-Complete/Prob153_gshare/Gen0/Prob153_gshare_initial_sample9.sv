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

  // Parameters
  localparam PHT_SIZE = 128;
  localparam PHT_IDX_BITS = 7;

  // 2-bit saturating counter states
  // 2'b00: Strongly Not Taken
  // 2'b01: Weakly Not Taken
  // 2'b10: Weakly Taken
  // 2'b11: Strongly Taken

  // Pattern History Table (PHT)
  reg [1:0] pht [0:PHT_SIZE-1];
  integer i;

  // Global History Register (GHR)
  reg [6:0] ghr;

  // Compute prediction index (XOR of pc and GHR)
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [1:0] predict_counter = pht[predict_index];

  // Prediction output signals
  assign predict_taken = predict_counter[1]; // MSB is prediction
  assign predict_history = ghr;

  // Compute training index (XOR of train_pc and train_history)
  wire [6:0] train_index = train_pc ^ train_history;
  reg [1:0] train_counter;

  // For updating PHT entry on train
  // saturating increment/decrement logic
  function [1:0] saturating_update;
    input [1:0] state;
    input taken;
    begin
      case(state)
        2'b00: saturating_update = taken ? 2'b01 : 2'b00;
        2'b01: saturating_update = taken ? 2'b10 : 2'b00;
        2'b10: saturating_update = taken ? 2'b11 : 2'b01;
        2'b11: saturating_update = taken ? 2'b11 : 2'b10;
        default: saturating_update = 2'b01; // default weakly not taken
      endcase
    end
  endfunction

  // Next GHR value after prediction update
  wire [6:0] ghr_next_pred;
  assign ghr_next_pred = {ghr[5:0], predict_taken};

  // Next GHR value after training update if mispredicted (recover)
  // If mispredicted, GHR is restored to train_history, otherwise it stays same
  wire [6:0] ghr_next_train;
  assign ghr_next_train = train_mispredicted ? train_history : ghr;

  // GHR next value selection priority:
  // If train_valid is high, train takes precedence (recover or keep)
  // Else if predict_valid is high, update GHR with prediction
  // Else keep GHR as is

  reg [6:0] ghr_next_reg;

  always @(*) begin
    if (train_valid)
      ghr_next_reg = ghr_next_train;
    else if (predict_valid)
      ghr_next_reg = ghr_next_pred;
    else
      ghr_next_reg = ghr;
  end

  // Sequential logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Initialize PHT to weakly not taken (2'b01)
      for (i = 0; i < PHT_SIZE; i = i + 1) begin
        pht[i] <= 2'b01;
      end
      ghr <= 7'b0;
    end else begin
      // Update PHT on training at next clock edge if train_valid
      if (train_valid) begin
        // Read old counter value
        train_counter = pht[train_index];
        // Update counter with actual taken
        pht[train_index] <= saturating_update(train_counter, train_taken);
      end

      // Update GHR
      ghr <= ghr_next_reg;
    end
  end

endmodule