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
  // Initialize to 2'b10 (weakly taken)
  reg [1:0] PHT [0:127];
  integer i;

  // Global History Register
  reg [6:0] GHR;

  // Indexing function: XOR of PC and GHR (7 bits each)
  wire [6:0] predict_index = predict_pc ^ GHR;
  wire [6:0] train_index = train_pc ^ train_history;

  // Current PHT state for prediction (read combinationally)
  wire [1:0] predict_pht_state = PHT[predict_index];

  // Prediction: taken if MSB of saturating counter is 1
  assign predict_taken = (predict_pht_state[1] == 1'b1);
  assign predict_history = GHR;

  // Next GHR value for prediction update (shift left by 1, insert predicted taken)
  wire [6:0] ghr_next_pred = {GHR[5:0], predict_taken};

  // Saturating counter update function
  function [1:0] sat_update;
    input [1:0] state;
    input taken;
    begin
      case (state)
        2'b00: sat_update = taken ? 2'b01 : 2'b00;
        2'b01: sat_update = taken ? 2'b10 : 2'b00;
        2'b10: sat_update = taken ? 2'b11 : 2'b01;
        2'b11: sat_update = taken ? 2'b11 : 2'b10;
        default: sat_update = 2'b10; // default weakly taken
      endcase
    end
  endfunction

  // Registers to hold PHT updates to apply at clock edge
  reg [1:0] train_pht_new;
  reg train_update_valid;
  reg [6:0] train_index_reg;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      GHR <= 7'b0;
      for (i = 0; i < 128; i = i + 1) begin
        PHT[i] <= 2'b10; // Initialize to weakly taken
      end
      train_update_valid <= 1'b0;
      train_index_reg <= 7'b0;
      train_pht_new <= 2'b10;
    end else begin
      // Apply PHT update if valid
      if (train_update_valid) begin
        PHT[train_index_reg] <= train_pht_new;
        train_update_valid <= 1'b0;
      end

      // Training logic: if train_valid, compute new counter and schedule update
      if (train_valid) begin
        // Read current PHT state at train_index
        reg [1:0] current_state;
        current_state = PHT[train_index];
        train_pht_new <= sat_update(current_state, train_taken);
        train_index_reg <= train_index;
        train_update_valid <= 1'b1;
      end

      // Update GHR: training takes precedence over prediction
      if (train_valid && train_mispredicted) begin
        // Recover GHR to train_history (state after mispredicted branch)
        GHR <= train_history;
      end else if (predict_valid && !(train_valid && train_mispredicted)) begin
        // Update GHR with prediction outcome
        GHR <= ghr_next_pred;
      end
      // Else keep GHR unchanged
    end
  end

endmodule