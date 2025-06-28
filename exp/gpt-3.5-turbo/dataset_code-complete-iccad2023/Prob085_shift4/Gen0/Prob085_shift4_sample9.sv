module TopModule (
  input clk,
  input areset,
  input load,
  input ena,
  input [3:0] data,
  output reg [3:0] q
);

  // D flip-flops for each bit of the shift register
  reg [3:0] q_temp;
  always @ (posedge clk or posedge areset)
    if (areset)
      q_temp <= 4'b0;
    else if (load)
      q_temp <= data;
    else if (ena)
      q_temp <= {1'b0, q[3:1]}; // Shift right
    
  // Output the values of the flip-flops to the register
  always @*
    q = q_temp;

endmodule