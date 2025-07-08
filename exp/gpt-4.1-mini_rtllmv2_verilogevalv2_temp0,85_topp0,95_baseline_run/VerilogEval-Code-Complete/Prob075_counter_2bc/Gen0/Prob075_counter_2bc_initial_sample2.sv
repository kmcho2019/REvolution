module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Asynchronous reset and synchronous update of the saturating counter
  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= 2'b01; // weakly not-taken
    end else if (train_valid) begin
      if (train_taken) begin
        if (state != 2'b11)
          state <= state + 1;
      end else begin
        if (state != 2'b00)
          state <= state - 1;
      end
    end
  end

endmodule