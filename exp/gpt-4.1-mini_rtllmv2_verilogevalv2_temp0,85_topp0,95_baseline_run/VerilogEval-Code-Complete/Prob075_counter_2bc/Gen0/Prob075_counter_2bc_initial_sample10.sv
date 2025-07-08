module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01; // weakly not-taken on reset
    end else if (train_valid) begin
      if (train_taken) begin
        if (state != 2'b11)
          state <= state + 1;
        else
          state <= state; // saturate at max 3
      end else begin
        if (state != 2'b00)
          state <= state - 1;
        else
          state <= state; // saturate at min 0
      end
    end else begin
      state <= state; // hold state if not training
    end
  end

endmodule