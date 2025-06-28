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
        if(a == 0 && clock == 1)
          state <= 2'b01; // Transition to state 1
        else
          state <= 2'b00;
      end
      2'b01: begin // State 1
        p <= 1;
        q <= (a == 1) ? 1 : 0;
        if(clock == 0)
          state <= 2'b00; // Transition to state 0
        else
          state <= 2'b01;
      end
      default: begin
        state <= 2'b00;
      end
    endcase
  end

endmodule