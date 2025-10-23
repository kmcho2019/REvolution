module TopModule(
  input clk,
  input areset,
  input in,
  output out
);

// Define the states as an enumeration
enum logic [1:0] {A, B, C, D} currentState, nextState;

// Sequential logic to update the current state and output
always_ff @(posedge clk or posedge areset) begin
  if (areset) begin
    // Reset the FSM to state A
    currentState <= A;
  end else begin
    // Update the current state
    currentState <= nextState;
  end
end

// Combinational logic to determine the next state and output
always_comb begin
  case (currentState)
    A: begin
      if (!in) begin
        nextState = A;
      end else begin
        nextState = B;
      end
      out = 0;
    end
    B: begin
      if (!in) begin
        nextState = C;
      end else begin
        nextState = B;
      end
      out = 0;
    end
    C: begin
      if (!in) begin
        nextState = A;
      end else begin
        nextState = D;
      end
      out = 0;
    end
    D: begin
      if (!in) begin
        nextState = C;
      end else begin
        nextState = B;
      end
      out = 1;
    end
    default: begin
      nextState = A;
      out = 0;
    end
  endcase
end

endmodule