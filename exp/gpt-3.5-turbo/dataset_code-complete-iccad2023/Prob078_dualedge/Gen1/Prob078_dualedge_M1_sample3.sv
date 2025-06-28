module TopModule (
  input clk,
  input d,
  output reg q
);

reg temp;

always @(posedge clk or negedge clk) begin
  if (~$past(clk)) begin // falling edge
    q <= temp;
  end
  else begin // rising edge
    temp <= d;
  end
endmodule