module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg [1:0] state;

  always @(posedge clock) begin
    case(state)
      2'b00: begin // State 0
        p <= 0; q <= 0;
        state <= a ? 2'b01 : 2'b00;
      end
      
      2'b01: begin // State 1
        p <= 1; q <= 0;
        state <= a ? 2'b10 : 2'b00;
      end

      2'b10: begin // State 2
        p <= state[0]; q <= 1;
        state <= a ? 2'b00 : 2'b10;
      end
    endcase
  end

endmodule