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
      q <= data; // Load data into the register
    end else if (ena) begin
      case(amount)
        2'b00: q <= {q[62:0], q[63]}; // Shift left by 1 bit
        2'b01: q <= (load) ? data : q << 8; // Load data or shift left by 8 bits
        2'b10: q <= {q[63], q[63:1]}; // Shift right by 1 bit (arithmetic)
        2'b11: q <= {q[63], q[63], q[63], q[63], q[63], q[63], q[63], q[63], q[63:8]}; // Shift right by 8 bits (arithmetic)
        default: q <= q; // No shift
      endcase
    end
  end

endmodule