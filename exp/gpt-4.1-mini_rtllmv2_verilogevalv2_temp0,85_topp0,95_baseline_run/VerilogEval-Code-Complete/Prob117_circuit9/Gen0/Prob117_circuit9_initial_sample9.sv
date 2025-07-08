module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

  always @(posedge clk) begin
    if (a)
      q <= 3'b100; // hold 4 when a is high
    else begin
      if (q == 3'd6)
        q <= 3'd0; // wrap around after 6
      else
        q <= q + 3'd1; // increment when a is low
    end
  end

endmodule