module TopModule (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  reg [99:0] reg_data;

  always @(posedge clk) begin
    if (load) // Load the shift register with data
      reg_data <= data;
    else begin
      if (ena == 2'b01) // Rotate right by one bit
        reg_data <= {reg_data[0], reg_data[99:1]};
      else if (ena == 2'b10) // Rotate left by one bit
        reg_data <= {reg_data[98:0], reg_data[99]};
    end
  end

  assign q = reg_data;

endmodule