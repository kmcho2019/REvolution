module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

  // Internal signals
  reg [3:0] internal_q;
  
  // Shift register
  always @(posedge clk) begin
    if (shift_ena)
      internal_q <= {data, internal_q[3:1]};
    else if (count_ena)
      internal_q <= internal_q - 1;
  end
  
  // Output
  always @(*) begin
    q = internal_q;
  end

endmodule