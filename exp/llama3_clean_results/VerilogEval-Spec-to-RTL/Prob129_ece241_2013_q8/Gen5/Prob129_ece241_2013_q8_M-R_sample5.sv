module TopModule (
  input clk,
  input aresetn,
  input x,
  output z
);

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10; // Parameterized state encodings

reg [1:0] state, next_state; // Separate registers for current and next states

// Combinational logic for state transitions
always @ (*) begin
  case (state)
    S0: begin
      if (x) begin
        next_state = S1;
      end else begin
        next_state = S0;
      end
    end
    S1: begin
      if (!x) begin
        next_state = S2;
      end else begin
        next_state = S1;
      end
    end
    S2: begin
      if (x) begin
        next_state = S1; // Recognized "101"
      end else begin
        next_state = S0;
      end
    end
  endcase
end

// Sequential logic for state update
always @ (posedge clk or negedge aresetn) begin
  if (!aresetn) begin // Async reset
    state <= S0;
  end else begin
    state <= next_state;
  end
end

// Output z is asserted when in S2 and x is '1'
assign z = (state == S2) && x;

endmodule