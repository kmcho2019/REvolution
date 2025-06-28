module ShiftRegister (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else if (ena) begin
      case(amount)
        2'b00: q <= {q[62:0], q[63]}; // Left shift by 1 bit
        2'b01: q <= {q[55:0], 8'b0}; // Left shift by 8 bits
        2'b10: q <= {q[0], q[63:1]}; // Right shift by 1 bit (arithmetic)
        2'b11: q <= {8'b0, q[63:8]}; // Right shift by 8 bits (arithmetic)
        default: q <= q; // No shift
      endcase
    end
  end

endmodule

module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output reg [63:0] q
);

  ShiftRegister shift_reg(
    .clk(clk),
    .load(load),
    .ena(ena),
    .amount(amount),
    .data(data),
    .q(q)
  );

endmodule