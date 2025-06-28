module TopModule (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  reg [99:0] reg_data;

  always @(posedge clk) begin
    if (load) begin
      reg_data <= data;
    end else begin
      // Shift register implementation
      if (ena[1] & ~ena[0]) begin
        // Rotate right
        reg_data <= {reg_data[99], reg_data[99:1]};
      end else if (~ena[1] & ena[0]) begin
        // Rotate left
        reg_data <= {reg_data[1:99], reg_data[0]};
      end
    end
  end

  assign q = reg_data;

endmodule