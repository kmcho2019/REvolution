module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01; // weakly not-taken
    end else if (train_valid) begin
      if (train_taken) begin
        // increment saturating at 3
        if (state != 2'b11)
          state <= state + 1;
      end else begin
        // decrement saturating at 0
        if (state != 2'b00)
          state <= state - 1;
      end
    end
    // if train_valid == 0, hold state
  end

endmodule