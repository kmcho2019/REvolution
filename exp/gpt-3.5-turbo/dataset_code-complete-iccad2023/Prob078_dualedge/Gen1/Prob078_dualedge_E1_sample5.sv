module TopModule (
  input clk,
  input d,
  output reg q
);

reg q_temp;
reg edge_trigger;

always @ (posedge clk or negedge clk)
begin
  edge_trigger <= clk ^ ~$past(clk);
end

always @ (posedge edge_trigger)
begin
  q_temp <= d;
end

always @ (posedge clk)
begin
  q <= q_temp;
end

endmodule