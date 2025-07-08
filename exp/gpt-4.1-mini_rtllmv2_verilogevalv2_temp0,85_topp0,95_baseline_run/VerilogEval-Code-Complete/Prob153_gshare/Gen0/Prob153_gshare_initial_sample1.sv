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

  // 2-bit saturating counters states:
  // 2'b00: Strongly not taken
  // 2'b01: Weakly not taken
  // 2'b10: Weakly taken
  // 2'b11: Strongly taken

  reg [1:0] PHT [0:127];
  reg [6:0] GHR;

  wire [6:0] predict_index = predict_pc ^ GHR;
  wire [1:0] predict_counter = PHT[predict_index];
  wire predict_bit = predict_counter[1]; // MSB is prediction

  // Outputs
  assign predict_taken = (predict_valid) ? predict_bit : 1'b0;
  assign predict_history = (predict_valid) ? GHR : 7'b0;

  // Training index
  wire [6:0] train_index = train_pc ^ train_history;
  reg [1:0] train_counter;
  reg [1:0] train_counter_next;

  // PHT update function for 2-bit saturating counter
  function [1:0] update_counter;
    input [1:0] cur;
    input taken;
    begin
      if (taken) begin
        if (cur != 2'b11)
          update_counter = cur + 1;
        else
          update_counter = cur;
      end else begin
        if (cur != 2'b00)
          update_counter = cur - 1;
        else
          update_counter = cur;
      end
    end
  endfunction

  integer i;

  // Asynchronous reset logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      GHR <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        PHT[i] <= 2'b10; // weakly taken on reset
    end else begin
      // Update PHT on training
      if (train_valid) begin
        train_counter = PHT[train_index];
        train_counter_next = update_counter(train_counter, train_taken);
        PHT[train_index] <= train_counter_next;
      end

      // Update GHR:
      // Priority: If train_valid && train_mispredicted then restore GHR to train_history
      // else if predict_valid update GHR with prediction bit
      if (train_valid && train_mispredicted) begin
        GHR <= train_history;
      end else if (predict_valid) begin
        GHR <= {GHR[5:0], predict_bit};
      end
      // else GHR unchanged
    end
  end

endmodule