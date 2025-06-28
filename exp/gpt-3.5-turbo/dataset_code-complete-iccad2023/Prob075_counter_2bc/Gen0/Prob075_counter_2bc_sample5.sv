module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  // Internal counter signal
  logic [1:0] counter;

  // Asynchronous reset
  always_ff @(posedge areset)
    if (areset)
      counter <= 2'b01;

  // Saturating counter logic
  always_comb begin
    case ({train_valid, train_taken})
      2'b11: // Increment when train_valid = 1 and train_taken = 1
        if (counter < 2'b11)
          counter <= counter + 1;
      2'b10: // Decrement when train_valid = 1 and train_taken = 0
        if (counter > 2'b00)
          counter <= counter - 1;
      default: // No change if not training
        counter <= counter;
    endcase
  end

  // Output the counter state
  assign state = counter;

endmodule