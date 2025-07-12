module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Control unit to determine shift operation
wire shift_left_1, shift_left_8, shift_right_1, shift_right_8;
assign shift_left_1 = (amount == 2'b00) && ena;
assign shift_left_8 = (amount == 2'b01) && ena;
assign shift_right_1 = (amount == 2'b10) && ena;
assign shift_right_8 = (amount == 2'b11) && ena;

// Shift left by 1 bit
wire [63:0] shift_left_1_out = {q_reg[62:0], 1'b0};

// Shift left by 8 bits
wire [63:0] shift_left_8_out = {q_reg[55:0], 8'b0};

// Shift right by 1 bit (arithmetic right shift)
wire [63:0] shift_right_1_out = {q_reg[63], q_reg[63:1]};

// Shift right by 8 bits (arithmetic right shift)
wire [63:0] shift_right_8_out = {{8{q_reg[63]}}, q_reg[63:8]};

// Hybrid shift logic
wire [63:0] next_q;
assign next_q = (load) ? data :
                 (shift_left_1) ? shift_left_1_out :
                 (shift_left_8) ? shift_left_8_out :
                 (shift_right_1) ? shift_right_1_out :
                 (shift_right_8) ? shift_right_8_out :
                 q_reg;

// Sequential logic
always @(posedge clk) begin
  q_reg <= next_q;
end

assign q = q_reg;

endmodule