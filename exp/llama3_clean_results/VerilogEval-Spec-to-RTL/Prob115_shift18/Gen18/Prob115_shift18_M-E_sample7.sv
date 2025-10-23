module ShiftUnit (
  input [63:0] data,
  input [1:0] amount,
  output [63:0] shifted_data
);

  always @(*) begin
    case (amount)
      2'b00: shifted_data = {data[62:0], 1'b0};
      2'b01: shifted_data = {data[55:0], 8'b0};
      2'b10: shifted_data = {{63{data[63]}}, data[63:1]};
      2'b11: shifted_data = {{56{data[63]}}, data[63:8]};
      default: shifted_data = data;
    endcase
  end

endmodule

module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

  reg [63:0] q_reg;

  ShiftUnit su (
    .data(q_reg),
    .amount(amount),
    .shifted_data(q_reg)
  );

  always @(posedge clk) begin
    if (load) begin
      q_reg <= data;
    end else if (ena) begin
      q_reg <= su.shifted_data;
    end
  end

  assign q = q_reg;

endmodule