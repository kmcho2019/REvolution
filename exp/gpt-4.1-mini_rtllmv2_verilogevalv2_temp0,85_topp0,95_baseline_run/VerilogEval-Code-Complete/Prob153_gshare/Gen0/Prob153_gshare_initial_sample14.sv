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
  // PHT: 128 entries of 2-bit saturating counters (2'b00 strongly not taken, 2'b11 strongly taken)
  reg [1:0] pht [0:127];
  // Global branch history register (7-bit)
  reg [6:0] ghr;

  // Hash function: XOR of 7-bit PC and 7-bit history to get 7-bit index
  wire [6:0] predict_index = predict_pc ^ ghr;
  wire [6:0] train_index = train_pc ^ train_history;

  // Prediction is combinational:
  // Read PHT at predict_index, predict_taken = MSB of counter >= 2 (2'b10 or 2'b11)
  // predict_history = ghr (history used for prediction)
  wire [1:0] predict_pht_state = pht[predict_index];
  assign predict_taken = (predict_pht_state[1] == 1'b1);
  assign predict_history = ghr;

  // Next GHR value depending on updates:
  // If train_valid and train_mispredicted, update ghr to train_history (recovery)
  // Else if predict_valid, update ghr with predicted taken bit
  // If both train and predict valid, train takes precedence
  reg [6:0] ghr_next;
  wire ghr_update_by_train = train_valid && train_mispredicted;
  wire ghr_update_by_predict = predict_valid && !ghr_update_by_train;

  always @(*) begin
    if (ghr_update_by_train)
      ghr_next = train_history;
    else if (ghr_update_by_predict)
      ghr_next = {ghr[5:0], predict_taken};
    else
      ghr_next = ghr; // no update
  end

  // Update PHT entry on training at posedge clk
  // Update counter saturating 2-bit: increment if taken, decrement if not taken
  // Only update if train_valid
  reg [1:0] pht_updated_value;
  wire [1:0] pht_train_value = pht[train_index];
  always @(*) begin
    if (!train_valid)
      pht_updated_value = pht_train_value;
    else if (train_taken) begin
      // increment saturating counter
      if (pht_train_value != 2'b11)
        pht_updated_value = pht_train_value + 2'b01;
      else
        pht_updated_value = pht_train_value;
    end else begin
      // decrement saturating counter
      if (pht_train_value != 2'b00)
        pht_updated_value = pht_train_value - 2'b01;
      else
        pht_updated_value = pht_train_value;
    end
  end

  integer i;
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      ghr <= 7'b0;
      // initialize PHT to weakly taken (2'b10) or weakly not taken (2'b01), choose weakly not taken (2'b01)
      for (i=0; i<128; i=i+1)
        pht[i] <= 2'b01;
    end else begin
      // Update GHR
      ghr <= ghr_next;
      // Update PHT if training valid
      if (train_valid)
        pht[train_index] <= pht_updated_value;
    end
  end

endmodule