module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Synchronous load
wire [63:0] load_next_q;
assign load_next_q = data;

// Shift left by 1 bit
wire [63:0] shift_left_1;
assign shift_left_1 = {q_reg[62:0], 1'b0};

// Shift left by 8 bits
wire [63:0] shift_left_8;
assign shift_left_8 = {q_reg[55:0], 8'b0};

// Shift right by 1 bit (arithmetic right shift)
wire [63:0] shift_right_1;
assign shift_right_1 = {q_reg[63], q_reg[63:1]};

// Shift right by 8 bits (arithmetic right shift)
wire [63:0] shift_right_8;
assign shift_right_8 = {q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63], q_reg[63:8]};

// Next state logic
wire [63:0] next_q;
assign next_q = (load) ? load_next_q :
                 (ena) ? (
                   (amount == 2'b00) ? shift_left_1 :
                   (amount == 2'b01) ? shift_left_8 :
                   (amount == 2'b10) ? shift_right_1 :
                   (amount == 2'b11) ? shift_right_8 :
                   q_reg
                 ) :
                 q_reg;

// Update state on clock edge
always @(posedge clk) begin
  q_reg <= next_q;
end

// Output assignment
assign q = q_reg;

endmodule