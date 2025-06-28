module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data instead of shifting
    end else if (ena) begin
      reg [63:0] temp; // Temporary variable for intermediate results
      case(amount)
        2'b00: temp = {q[62:0], q[63]}; // Shift left by 1 bit
        2'b01: temp = {q[55:0], 8'b0}; // Shift left by 8 bits
        2'b10: temp = {q[63], q[63:1]}; // Shift right by 1 bit (arithmetic right shift)
        2'b11: temp = {q[7:0], q[63:8]}; // Shift right by 8 bits (arithmetic right shift)
        default: temp = q;
      endcase
      q <= temp; // Update q with the shifted value
    end
  end

endmodule