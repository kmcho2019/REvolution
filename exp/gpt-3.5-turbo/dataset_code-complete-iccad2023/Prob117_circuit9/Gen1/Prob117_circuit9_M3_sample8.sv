module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg [1:0] a_delayed;

always @ (posedge clk) begin
  a_delayed <= {a_delayed[0], a}; // Delay 'a' by 1 clock cycle

  if (a == 1'b1) begin
    if (q < 3'd6) // Counter should increment from 0 to 6
      q <= q + 1;
  end else if ((a == 1'b0) && (a_delayed == 2'b01)) begin
    q <= 3'b0; // Reset counter to 0 when 'a' transitions from 1 to 0 continuously
  end
end

endmodule