module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  always @(posedge clock or negedge clock) begin
    if (clock) begin
      p <= a;
      q <= p;
    end else begin
      p <= p;
      q <= p;
    end
  end

endmodule