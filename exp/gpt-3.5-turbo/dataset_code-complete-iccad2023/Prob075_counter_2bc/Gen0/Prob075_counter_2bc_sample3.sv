module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Registers for the counter value
  logic [1:0] counter;

  always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
      // Reset to weakly not-taken
      counter <= 2'b01;
    end else begin
      if (train_valid) begin
        if (train_taken && (counter < 2'b11)) begin
          // Increment counter if not at maximum
          counter <= counter + 1;
        end else if (!train_taken && (counter > 2'b00)) begin
          // Decrement counter if not at minimum
          counter <= counter - 1;
        end
      end
    end
  end

  // Output the current counter value
  assign state = counter;

endmodule