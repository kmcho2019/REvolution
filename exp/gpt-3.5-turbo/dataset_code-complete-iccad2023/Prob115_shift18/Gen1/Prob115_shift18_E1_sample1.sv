module ShiftRegister (
  input [63:0] in_data,
  input shift_left_1,
  input shift_left_8,
  input shift_right_1,
  input shift_right_8,
  output reg [63:0] out_data
);

  // 64-bit shift register for left shift by 1 bit
  reg [63:0] left_shift_1_data;
  always @* begin
    left_shift_1_data = {left_shift_1_data[62:0], left_shift_1_data[63]};
  end
  
  // 64-bit shift register for left shift by 8 bits
  reg [63:0] left_shift_8_data;
  always @* begin
    left_shift_8_data = {left_shift_8_data[55:0], left_shift_8_data[63:56]};
  end
  
  // 64-bit shift register for right shift by 1 bit
  reg [63:0] right_shift_1_data;
  always @* begin
    right_shift_1_data = {right_shift_1_data[0], right_shift_1_data[63:1]};
  end
  
  // 64-bit shift register for right shift by 8 bits (arithmetic shift)
  reg [63:0] right_shift_8_data;
  always @* begin
    right_shift_8_data = {right_shift_8_data[7], right_shift_8_data[63:8]};
  end
  
  // Multiplexer to select the output data based on shift direction
  always @* begin
    case({shift_left_1, shift_left_8, shift_right_1, shift_right_8})
      4'b0001: out_data = left_shift_1_data;
      4'b0010: out_data = left_shift_8_data;
      4'b0100: out_data = right_shift_1_data;
      4'b1000: out_data = right_shift_8_data;
      default: out_data = in_data; // No shift
    endcase
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

  wire shift_left_1 = (amount == 2'b00) ? 1 : 0;
  wire shift_left_8 = (amount == 2'b01) ? 1 : 0;
  wire shift_right_1 = (amount == 2'b10) ? 1 : 0;
  wire shift_right_8 = (amount == 2'b11) ? 1 : 0;
  
  ShiftRegister sr (
    .in_data(data),
    .shift_left_1(shift_left_1),
    .shift_left_8(shift_left_8),
    .shift_right_1(shift_right_1),
    .shift_right_8(shift_right_8),
    .out_data(q)
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else if (ena) begin
      // No additional actions needed here, handled in ShiftRegister module 
    end
  end

endmodule