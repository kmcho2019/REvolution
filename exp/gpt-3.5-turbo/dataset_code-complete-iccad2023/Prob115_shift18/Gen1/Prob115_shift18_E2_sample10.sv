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
      q <= data; // Load data when 'load' signal is high
    end else begin
      case(amount)
        2'b00: q <= ena ? {q[62:0], q[63]} : q; // Left shift by 1 bit when ena is high
        2'b01: q <= ena ? {q[55:0], q[63:8]} : q; // Left shift by 8 bits when ena is high
        2'b10: q <= ena ? {q[63], q[63:1]} : q; // Arithmetic right shift by 1 bit when ena is high
        2'b11: q <= ena ? {q[7:0], q[63:8]} : q; // Arithmetic right shift by 8 bits when ena is high
        default: q <= q; // No shift
      endcase
    end
  end

endmodule