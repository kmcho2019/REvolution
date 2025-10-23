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
wire [1:0] shift_amount;
wire shift_left;
wire shift_right;
assign shift_amount = amount;
assign shift_left = (amount == 2'b00 || amount == 2'b01);
assign shift_right = (amount == 2'b10 || amount == 2'b11);

// Shift left by 1 bit
wire [63:0] shift_left_1 = {q_reg[62:0], 1'b0};

// Shift left by 8 bits
wire [63:0] shift_left_8 = {q_reg[55:0], 8'b0};

// Shift right by 1 bit (arithmetic right shift)
wire [63:0] shift_right_1 = {q_reg[63], q_reg[63:1]};

// Shift right by 8 bits (arithmetic right shift)
wire [63:0] shift_right_8 = {{8{q_reg[63]}}, q_reg[63:8]};

// Hybrid shift logic
wire [63:0] next_q;
assign next_q = (load)? data :
                 (ena)? (
                   (shift_left)? (
                     (shift_amount == 2'b00)? shift_left_1 : shift_left_8
                   ) : (
                     (shift_right)? (
                       (shift_amount == 2'b10)? shift_right_1 : shift_right_8
                     ) : q_reg
                   )
                 ) : q_reg;

// Sequential logic
always @(posedge clk) begin
  q_reg <= next_q;
end

assign q = q_reg;

endmodule