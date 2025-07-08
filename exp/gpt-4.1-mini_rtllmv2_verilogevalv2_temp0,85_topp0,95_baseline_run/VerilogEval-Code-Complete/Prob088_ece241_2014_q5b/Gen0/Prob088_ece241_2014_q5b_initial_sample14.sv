module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // One-hot encoded states
  reg state_A, state_B;
  reg next_state_A, next_state_B;

  // State register with asynchronous active-high reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state_A <= 1'b1;
      state_B <= 1'b0;
    end else begin
      state_A <= next_state_A;
      state_B <= next_state_B;
    end
  end

  // Next state logic
  always @(*) begin
    case ({state_A, state_B})
      2'b10: begin // state A
        if (x == 1'b0) begin
          next_state_A = 1'b1;
          next_state_B = 1'b0;
        end else begin
          next_state_A = 1'b0;
          next_state_B = 1'b1;
        end
      end
      2'b01: begin // state B
        next_state_A = 1'b0;
        next_state_B = 1'b1;
      end
      default: begin
        // invalid state, reset to state A
        next_state_A = 1'b1;
        next_state_B = 1'b0;
      end
    endcase
  end

  // Output logic (Mealy output depends on current state and input)
  always @(*) begin
    case ({state_A, state_B})
      2'b10: begin // state A
        z = (x == 1'b1) ? 1'b1 : 1'b0;
      end
      2'b01: begin // state B
        z = (x == 1'b0) ? 1'b1 : 1'b0;
      end
      default: begin
        z = 1'b0;
      end
    endcase
  end

endmodule