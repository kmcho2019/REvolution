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

  // Pattern History Table (128 entries of 2-bit saturating counters)
  reg [1:0] pht [0:127];
  
  // Global History Register
  reg [6:0] ghr;
  
  // Prediction index (XOR of PC and GHR)
  wire [6:0] predict_index = predict_pc ^ ghr;
  
  // Training index (XOR of PC and history)
  wire [6:0] train_index = train_pc ^ train_history;
  
  // Current prediction output
  assign predict_taken = pht[predict_index][1];  // MSB determines taken/not taken
  assign predict_history = ghr;
  
  // Initialize PHT to weakly taken (01)
  integer i;
  initial begin
    for (i = 0; i < 128; i = i + 1)
      pht[i] = 2'b01;
  end
  
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset GHR to 0 and PHT to weakly taken
      ghr <= 7'b0;
      for (i = 0; i < 128; i = i + 1)
        pht[i] <= 2'b01;
    end else begin
      // Training takes precedence over prediction
      if (train_valid) begin
        // Update PHT based on actual outcome
        if (train_taken) begin
          // Increment counter (saturate at 3)
          if (pht[train_index] != 2'b11)
            pht[train_index] <= pht[train_index] + 1;
        end else begin
          // Decrement counter (saturate at 0)
          if (pht[train_index] != 2'b00)
            pht[train_index] <= pht[train_index] - 1;
        end
        
        // If mispredicted, restore GHR to training history + outcome
        if (train_mispredicted)
          ghr <= {train_history[5:0], train_taken};
      end else if (predict_valid) begin
        // For prediction, update GHR with prediction
        ghr <= {ghr[5:0], predict_taken};
      end
    end
  end

endmodule