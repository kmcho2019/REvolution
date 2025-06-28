module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

reg a_prev;
reg [2:0] q_temp;

always @ (posedge clk) begin
  if (a == 1'b1 && a_prev == 1'b0) begin
    if (q < 3'd6)
      q_temp <= q + 1;
    else
      q_temp <= 3'd0;
  end else if (a == 1'b1) begin
    q_temp <= q;
  end else begin // a == 0
    q_temp <= q_temp; // Retain previous value
  end
  a_prev <= a;
end

always @* begin
  q <= q_temp;
end

endmodule