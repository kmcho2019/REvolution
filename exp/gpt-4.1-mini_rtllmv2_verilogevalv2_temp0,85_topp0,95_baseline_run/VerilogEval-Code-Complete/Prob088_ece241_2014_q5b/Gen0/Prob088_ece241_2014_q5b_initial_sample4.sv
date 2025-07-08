module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot encoded states
  reg state_A, state_B;

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      // Next state logic
      case (1'b1) // one-hot encoded states
        state_A: begin
          if (x == 1'b0) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
          end else begin
            state_A <= 1'b0;
            state_B <= 1'b1;
          end
        end
        state_B: begin
          state_A <= 1'b0;
          state_B <= 1'b1;
        end
        default: begin
          // Default to state A if invalid state occurs
          state_A <= 1'b1;
          state_B <= 1'b0;
        end
      endcase
    end
  end

  // Output logic (Mealy output depends on current state and input)
  always @(*) begin
    if (state_A) begin
      z = x;       // z = 0 if x=0, z=1 if x=1
    end else if (state_B) begin
      z = ~x;      // z = 1 if x=0, z=0 if x=1
    end else begin
      z = 1'b0;    // safe default
    end
  end

endmodule