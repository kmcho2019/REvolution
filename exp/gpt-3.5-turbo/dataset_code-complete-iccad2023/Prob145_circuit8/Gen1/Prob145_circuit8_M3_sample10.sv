module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg state;

  always @(posedge clock or negedge clock) begin
    if (~clock) begin // Falling edge of clock
      state <= 1'b0;
      p <= 0;
      q <= 0;
    end else if (state) begin // State 1
      p <= 1;
      q <= a; // q follows the value of 'a'
      state <= (a) ? 1 : 0;
    end
  end

endmodule