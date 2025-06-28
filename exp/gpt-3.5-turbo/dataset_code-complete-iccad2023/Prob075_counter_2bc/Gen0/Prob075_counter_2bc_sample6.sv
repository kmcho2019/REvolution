module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Internal signal to hold the current counter value
  logic [1:0] counter_value;

  always_comb begin
    // Increment counter when train_valid = 1 and train_taken = 1
    if (train_valid && train_taken && (counter_value != 2'b11))
      counter_value = counter_value + 2'b01;
    // Decrement counter when train_valid = 1 and train_taken = 0
    else if (train_valid && !train_taken && (counter_value != 2'b00))
      counter_value = counter_value - 2'b01;
  end

  // Asynchronous reset
  always_ff @(posedge clk or posedge areset)
    if (areset)
      counter_value <= 2'b01; // Reset to weakly not-taken
    else
      state <= counter_value;

endmodule