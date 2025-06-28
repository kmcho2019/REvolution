module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [7:0] d_lower;
reg [7:0] q_lower;
reg [7:0] d_upper;
reg [7:0] q_upper;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    q <= 16'b0;
    q_upper <= 8'b0;
    q_lower <= 8'b0;
  end else begin
    // Update lower byte DFFs
    if (byteena[0]) begin
      d_lower <= d[7:0];
      q_lower <= d[7:0];
    end else begin
      d_lower <= q_lower;
    end

    // Update upper byte DFFs
    if (byteena[1]) begin
      d_upper <= d[15:8];
      q_upper <= d[15:8];
    end else begin
      d_upper <= q_upper;
    end

    q = {q_upper, q_lower};
  end
end

endmodule