module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

wire [63:0] shift_left_1;
wire [63:0] shift_left_8;
wire [63:0] shift_right_1;
wire [63:0] shift_right_8;

ShiftLeft1 shift_left_1_module (
  .data(q_reg),
  .output(shift_left_1)
);

ShiftLeft8 shift_left_8_module (
  .data(q_reg),
  .output(shift_left_8)
);

ShiftRight1 shift_right_1_module (
  .data(q_reg),
  .output(shift_right_1)
);

ShiftRight8 shift_right_8_module (
  .data(q_reg),
  .output(shift_right_8)
);

wire [1:0] decoder_out;
Decoder decoder_module (
  .input(amount),
  .output(decoder_out)
);

wire [63:0] q_next;
Multiplexer4x1 multiplexer_module (
  .input0(data),
  .input1(shift_left_1),
  .input2(shift_left_8),
  .input3(shift_right_1),
  .input4(shift_right_8),
  .select(decoder_out),
  .output(q_next)
);

always @(posedge clk) begin
  if (load) begin
    q_reg <= data;
  end else if (ena) begin
    q_reg <= q_next;
  end
end

assign q = q_reg;

endmodule

module ShiftLeft1 (
  input [63:0] data,
  output [63:0] output
);

assign output = {data[62:0], 1'b0};

endmodule

module ShiftLeft8 (
  input [63:0] data,
  output [63:0] output
);

assign output = {data[55:0], 8'b0};

endmodule

module ShiftRight1 (
  input [63:0] data,
  output [63:0] output
);

assign output = {data[63], data[63:1]};

endmodule

module ShiftRight8 (
  input [63:0] data,
  output [63:0] output
);

assign output = {{8{data[63]}}, data[63:8]};

endmodule

module Decoder (
  input [1:0] input,
  output [1:0] output
);

assign output = (input == 2'b00) ? 2'b01 :
                (input == 2'b01) ? 2'b10 :
                (input == 2'b10) ? 2'b11 :
                (input == 2'b11) ? 2'b12 : 2'b00;

endmodule

module Multiplexer4x1 (
  input [63:0] input0,
  input [63:0] input1,
  input [63:0] input2,
  input [63:0] input3,
  input [63:0] input4,
  input [1:0] select,
  output [63:0] output
);

assign output = (select == 2'b01) ? input0 :
                (select == 2'b10) ? input1 :
                (select == 2'b11) ? input2 :
                (select == 2'b12) ? input3 : input4;

endmodule