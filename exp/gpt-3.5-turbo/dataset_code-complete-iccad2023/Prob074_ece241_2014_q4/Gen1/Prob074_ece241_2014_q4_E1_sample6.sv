module TopModule (
  input clk,
  input x,
  output reg z
);

reg [2:0] shift_register;

always @(posedge clk) begin
  // Update the shift register by shifting in the output of each gate
  shift_register <= {x ^ shift_register[0], ~(x & shift_register[1]), ~(x | shift_register[2])};
end

assign z = ~(shift_register[0] | shift_register[1] | shift_register[2]);

endmodule