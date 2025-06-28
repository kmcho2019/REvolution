module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg [1:0] state; // Define a 2-bit state variable

  always @(posedge clock) begin
    case(state)
      2'b00: begin // State 0
        p <= 0;
        q <= 0;
        if(a == 0)
          state <= 2'b00; // Stay in State 0
        else
          state <= 2'b01; // Transition to State 1
      end
      2'b01: begin // State 1
        p <= 1;
        q <= (a == 1) ? 1 : 0; // Set q to 1 if a transitions from 0 to 1
        state <= 2'b10; // Transition to State 2
      end
      2'b10: begin // State 2
        p <= (clock == 1) ? 1 : 0; // Maintain p when clock is 1
        if(clock == 1)
          state <= 2'b00; // Transition back to State 0
        else
          state <= 2'b10; // Stay in State 2
      end
    endcase
  end

endmodule