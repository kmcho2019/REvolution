module TopModule (
  input clk,
  input resetn,
  input in,
  output reg out
);

reg [3:0] d_ff; // 4-bit shift register using D flip-flops

// D flip-flop chain
always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    d_ff <= 4'b0;
  end else begin
    d_ff <= {d_ff[2:0], in}; // Shift data to the right
  end
end

assign out = d_ff[3];

endmodule