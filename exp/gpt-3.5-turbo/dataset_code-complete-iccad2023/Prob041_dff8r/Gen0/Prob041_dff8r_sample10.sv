module TopModule (
  input clk,
  input [7:0] d,
  input reset,
  output reg [7:0] q
);

reg [7:0] q_temp;

always @ (posedge clk or posedge reset)
begin
  if (reset)
    q_temp <= 8'b0;
  else
  begin
    for (int i = 0; i < 8; i=i+1)
    begin
      if (i == 0)
        q_temp[i] <= d[i];
      else
        q_temp[i] <= q_temp[i-1];
    end
  end
end

always @ (*)
begin
  q <= q_temp;
end

endmodule