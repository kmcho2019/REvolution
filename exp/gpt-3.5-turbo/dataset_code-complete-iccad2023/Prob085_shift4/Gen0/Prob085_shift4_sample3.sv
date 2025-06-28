module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

// Right shift operation
always @(posedge clk) begin
  if (areset) begin
    q <= 4'b0000; // Reset to zero
  end else begin
    if (load) begin
      q <= {data, q[3]}; // Load data instead of shifting
    end else if (ena) begin
      q <= {1'b0, q[3:1]}; // Right shift
    end
  end
end

endmodule