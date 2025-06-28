module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

  always @(posedge clk) begin
    if (areset) begin
      q <= 4'b0000;
    end else if (load) begin
      q <= data;
    end else if (ena) begin
      q <= {q[3], q[2:0]};
    end
  end

endmodule