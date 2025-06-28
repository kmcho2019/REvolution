module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  reg [63:0] temp_q;

  always @(posedge clk) begin
    if (load) begin
      temp_q <= data;
    end else if (ena) begin
      case(amount)
        2'b00: temp_q <= {temp_q[62:0], temp_q[63]}; // Shift left by 1 bit
        2'b01: temp_q <= {temp_q[55:0], temp_q[63:56]}; // Shift left by 8 bits
        2'b10: temp_q <= {temp_q[63], temp_q[63:1]}; // Shift right by 1 bit (arithmetic right shift)
        2'b11: temp_q <= {temp_q[7], temp_q[63:8]}; // Shift right by 8 bits (arithmetic right shift)
      endcase
    end
  end

  always @* begin
    q = temp_q;
  end

endmodule