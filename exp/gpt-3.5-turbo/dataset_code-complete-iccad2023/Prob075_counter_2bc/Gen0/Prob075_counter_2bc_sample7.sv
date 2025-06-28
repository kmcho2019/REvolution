module TopModule (
  input clk,
  input areset,
  input train_valid,
  input train_taken,
  output logic [1:0] state
);

  logic [1:0] counter;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      counter <= 2'b01; // Reset to weakly not-taken
    end else begin
      if (train_valid) begin
        if (train_taken && (counter < 2'b11)) begin
          counter <= counter + 1; // Increment when valid and taken
        end
        if (!train_taken && (counter > 2'b00)) begin
          counter <= counter - 1; // Decrement when valid and not taken
        end
      end
    end
  end

  assign state = counter;

endmodule