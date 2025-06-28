module TopModule (
  input clk,
  input areset,
  input x,
  output z
);

  // Define the states using one-hot encoding
  parameter A = 1'b1;
  parameter B = 1'b0;

  // Define the state register
  reg state, next_state;

  // Output wire
  wire z;

  // Mealy state and output logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
      z <= 1'b0;
    end
    else begin
      state <= next_state;
      z <= (state == A && x) ? 1'b1 : 1'b0;
    end
  end

  // Next state logic
  always @(*) begin
    case(state)
      A: begin
        if (x)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        if (x)
          next_state = B;
        else
          next_state = B;
      end
    endcase
  end

endmodule