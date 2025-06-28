module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Internal signals
  logic [1:0] next_state;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      // Synchronous reset to 2'b01
      state <= 2'b01;
    end else begin
      // Default assignment to keep the value unchanged
      next_state = state;
      
      // Update the counter based on the conditions
      if (train_valid) begin
        if (train_taken && (state != 2'b11)) begin
          next_state = state + 1;
        end else if (!train_taken && (state != 2'b00)) begin
          next_state = state - 1;
        end
      end
      
      // Update the state only after all conditions checked
      state <= next_state;
    end
  end
endmodule