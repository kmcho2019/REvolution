module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  reg [1:0] counter;

  // Saturating counter logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      counter <= 2'b01; // Initialize to weakly not-taken
    end
    else begin
      case ({train_valid, train_taken})
        2'b11: counter <= (counter == 2'b11) ? counter : counter + 2'b01; // Increment
        2'b10: counter <= (counter == 2'b00) ? counter : counter - 2'b01; // Decrement
        default: counter <= counter; // No change
      endcase
    end
  end

  assign state = counter;

endmodule