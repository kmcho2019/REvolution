module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

  reg [3:0] q_tmp;

  always @(posedge clk or posedge areset)
  begin
    if (areset)
      q_tmp <= 4'b0;
    else if (load)
      q_tmp <= data;
    else if (ena)
      q_tmp <= {1'b0, q_tmp[3:1]};
  end

  always @(posedge clk)
  begin
    q <= q_tmp;
  end
endmodule