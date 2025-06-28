module TopModule (
  input clk,
  input load,
  input [1:0] ena,
  input [99:0] data,
  output reg [99:0] q
);

  reg [99:0] shift_register;
  reg [99:0] shifted_out;

  always @(posedge clk) begin
    if (load) begin
      shift_register <= data;
    end else begin
      shifted_out <= (ena == 2'b10) ? shift_register[0] : shift_register[99];
      if (ena == 2'b01) begin
        shift_register <= {shifted_out, shift_register[99:1]};
      end else if (ena == 2'b10) begin
        shift_register <= {shift_register[98:0], shifted_out};
      end
    end
    q <= shift_register;
  end

endmodule