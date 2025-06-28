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
    end else begin
      case(amount)
        2'b00: q <= ena ? {q[62:0], q[63]} : q; // Shift left by 1 bit
        2'b01: q <= ena ? {q[55:0], 8'b0} : q; // Shift left by 8 bits
        2'b10: q <= ena ? {q[63], q[63:1]} : q; // Shift right by 1 bit (arithmetic right shift)
        2'b11: q <= ena ? {q[63:8], {56{q[63]}}} : q; // Shift right by 8 bits (arithmetic right shift)
        default: q <= q; // No shift
      endcase
    end
  end

endmodule