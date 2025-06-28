module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Define the internal counter variable
  logic [1:0] counter;

  always_ff @(posedge clk or posedge areset) begin
    // Reset the counter to 2'b01 when areset is active
    if (areset) begin
      counter <= 2'b01;
    end
    else begin
      // Increment the counter when train_valid = 1 and train_taken = 1
      if (train_valid && train_taken && counter < 3) begin
        counter <= counter + 2'b01;
      end
      // Decrement the counter when train_valid = 1 and train_taken = 0
      else if (train_valid && !train_taken && counter > 0) begin
        counter <= counter - 2'b01;
      end
    end
  end

  assign state = counter;

endmodule